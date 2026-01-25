#include <WiFi.h>
#include <WebSocketsClient.h> // By Markus Sattler
#include <ArduinoJson.h>      // By Benoit Blanchon
#include <FastLED.h>

// --- CONFIGURATION ---
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Supabase Realtime WebSocket URL
// Format: wss://[REF].supabase.co/realtime/v1/websocket?apikey=[KEY]&vsn=1.0.0
const char* ws_host = "ehhntqueiwfbxcvnnbdl.supabase.co"; 
const char* api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."; // Your Anon Key
const int ws_port = 443;

// Hardware Pins (XIAO ESP32-S3)
#define LED_PIN     D0
#define NUM_LEDS    30
CRGB leds[NUM_LEDS];

WebSocketsClient webSocket;

// --- LED LOGIC ---
void updateLEDs(float x, float y, float z, bool active) {
  if (!active) {
    fadeToBlackBy(leds, NUM_LEDS, 20); // Smooth ghosting effect when hand lost
  } else {
    // Map X (-25 to 25) to Hue (Purple to Pink)
    // 192 is Purple, 224 is Pink/Magenta in FastLED HSV
    uint8_t hue = map(x, -25, 25, 190, 240);
    
    // Map Z (-40 to -5) to Brightness
    uint8_t bright = map(z, -40, -5, 50, 255);
    
    fill_solid(leds, NUM_LEDS, CHSV(hue, 255, bright));
  }
  FastLED.show();
}

// --- WEBSOCKET HANDLER ---
void onMessage(WStype_t type, uint8_t * payload, size_t length) {
  switch(type) {
    case WStype_TEXT: {
      StaticJsonDocument<1024> doc;
      deserializeJson(doc, payload);

      // Supabase Realtime wraps data in a "payload" object
      JsonObject data = doc["payload"];
      if (data.containsKey("right")) {
        float x = data["right"]["wrist"][0];
        float z = data["right"]["wrist"][2];
        bool tracked = data["right"]["tracked"];
        updateLEDs(x, 0, z, tracked);
      }
      break;
    }
    case WStype_CONNECTED:
      // Join the specific channel once connected
      webSocket.sendTXT("{\"topic\":\"realtime:air-music\",\"event\":\"phx_join\",\"payload\":{},\"ref\":\"1\"}");
      break;
  }
}

void setup() {
  Serial.begin(115200);
  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) delay(500);

  // Setup Secure WebSocket
  String url = "/realtime/v1/websocket?apikey=" + String(api_key) + "&vsn=1.0.0";
  webSocket.beginSSL(ws_host, ws_port, url.c_str());
  webSocket.onEvent(onMessage);
  webSocket.setReconnectInterval(5000);
}

void loop() {
  webSocket.loop();
}