# Lucid Weave Firmware (ESP32)

This folder contains the **wearable firmware** that drives the **fiber optic dress LEDs** in Lucid Weave.

## What it does
- Connects to **Supabase Realtime** over WebSocket (Phoenix protocol)
- Listens for `broadcast` messages that contain hand-tracking data
- Maps spatial parameters to LED **color** and **brightness**
- Smoothly fades out when tracking is lost

## Hardware
- MCU: **XIAO ESP32-S3** (works with other ESP32 boards too)
- LEDs: **WS2812B** (GRB), side-glow fiber optic bundles supported

## Libraries
Install via Arduino Library Manager:
- **WebSockets** (Markus Sattler)
- **ArduinoJson** (Benoit Blanchon)
- **FastLED**

## Setup
1. Copy secrets file
   - Duplicate `secrets.h.example`
   - Rename to `secrets.h`
   - Fill in your WiFi + Supabase settings

2. Open `lucid_weave_firmware.ino` in Arduino IDE

3. Select board + port
   - Board: XIAO ESP32S3 (or your ESP32 board)
   - Port: the serial port shown after connecting USB

4. Upload

## Message format expected
The firmware supports common Supabase Realtime broadcast frames like:

```json
{
  "topic": "realtime:air-music",
  "event": "broadcast",
  "payload": {
    "event": "controls",
    "payload": {
      "right": { "tracked": true, "wrist": [x,y,z] },
      "left":  { "tracked": false, "wrist": [x,y,z] }
    }
  }
}
