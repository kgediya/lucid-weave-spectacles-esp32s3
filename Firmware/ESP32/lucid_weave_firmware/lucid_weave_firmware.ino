/**
 * Lucid Weave — ESP32 Wearable Firmware
 * -----------------------------------
 * Listens to Supabase Realtime (Phoenix WS) "broadcast" messages and
 * maps incoming hand-tracking to LED color/brightness.
 *
 * Board: XIAO ESP32-S3 (works on other ESP32 boards too)
 * LEDs : WS2812B (GRB), side-glow fiber optic bundles etc.
 *
 * Dependencies (Arduino Library Manager):
 *  - WebSockets by Markus Sattler
 *  - ArduinoJson by Benoit Blanchon
 *  - FastLED
 *
 * SECURITY NOTE:
 *  - This example uses webSocket.setInsecure() for simplicity (no cert pinning).
 *  - For production/public demos, consider setting CA cert / fingerprint pinning.
 */

#include "secrets.h"

#include <WiFi.h>
#include <WebSocketsClient.h> // Markus Sattler
#include <ArduinoJson.h>      // Benoit Blanchon
#include <FastLED.h>

// ---------------------------
// Hardware config
// ---------------------------
#ifndef LED_PIN
  #define LED_PIN     D0
#endif

#ifndef NUM_LEDS
  #define NUM_LEDS    30
#endif

#ifndef LED_TYPE
  #define LED_TYPE    WS2812B
#endif

#ifndef COLOR_ORDER
  #define COLOR_ORDER GRB
#endif

CRGB leds[NUM_LEDS];

// ---------------------------
// Supabase Realtime config
// ---------------------------
// Supabase Realtime WS path format (Phoenix):
// /realtime/v1/websocket?apikey=...&vsn=1.0.0
static const int WS_PORT = 443;

// You can keep this stable. If you rename channels later, update it.
static const char* TOPIC = "realtime:air-music";

// Optional: If you broadcast under a named event, you can filter it.
// Leave empty "" to accept all broadcast events.
static const char* EVENT_FILTER = "controls";

// ---------------------------
// Runtime
// ---------------------------
WebSocketsClient webSocket;

static uint32_t lastMsgMs = 0;
static bool isJoined = false;

// Hand state cached
struct HandState {
  bool tracked = false;
  float x = 0;
  float y = 0;
  float z = 0;
};

static HandState rightHand;
static HandState leftHand;

// ---------------------------
// Helpers
// ---------------------------
static int clampi(int v, int lo, int hi) {
  if (v < lo) return lo;
  if (v > hi) return hi;
  return v;
}

static uint8_t mapToByte(float v, float inMin, float inMax, int outMin, int outMax) {
  // float -> int mapping with clamps
  if (inMax == inMin) return (uint8_t)outMin;
  float t = (v - inMin) / (inMax - inMin);
  t = (t < 0.f) ? 0.f : (t > 1.f ? 1.f : t);
  int out = (int)(outMin + t * (outMax - outMin));
  out = clampi(out, 0, 255);
  return (uint8_t)out;
}

static void setAll(const CHSV& hsv) {
  fill_solid(leds, NUM_LEDS, hsv);
  FastLED.show();
}

static void fadeGhost(uint8_t amount = 20) {
  fadeToBlackBy(leds, NUM_LEDS, amount);
  FastLED.show();
}

// ---------------------------
// LED mapping (tweakable)
// ---------------------------
static void updateLEDsFromHand(const HandState& h) {
  if (!h.tracked) {
    // Smooth fade when hand is lost
    fadeGhost(20);
    return;
  }

  // Map X to Hue (purple->magenta)
  // Feel free to tweak these bounds based on your Spectacles coordinate range
  // Example incoming X range: -25..25
  uint8_t hue = mapToByte(h.x, -25.f, 25.f, 190, 240);

  // Map Z to brightness (further away = dimmer or vice versa)
  // Example Z range: -40..-5
  uint8_t bright = mapToByte(h.z, -40.f, -5.f, 50, 255);

  setAll(CHSV(hue, 255, bright));
}

// Choose which hand drives the wearable
static const HandState& pickLeadHand() {
  if (rightHand.tracked) return rightHand;
  if (leftHand.tracked)  return leftHand;
  return rightHand; // default ref
}

// ---------------------------
// Supabase / Phoenix protocol
// ---------------------------
static void sendJoin() {
  // Phoenix join frame:
  // {"topic":"realtime:.
