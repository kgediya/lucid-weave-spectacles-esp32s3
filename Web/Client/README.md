# Lucid Weave Web Client

A cinematic browser client that visualizes and sonifies spatial hand gestures.

## What it does
- Subscribes to Supabase Realtime broadcast messages
- Renders volumetric sparkle trails using three.js
- Generates an FM style synth voice with Web Audio
- Highlights the active Do Re Mi marker

## Setup
1. Copy config
   - Duplicate `config.example.js`
   - Rename to `config.js`
   - Fill `SUPABASE_URL` and `SUPABASE_ANON_KEY`

2. Run locally
   - Use any static server:
     - VSCode Live Server
     - `python -m http.server` from `web/client`

3. Click **ENTER THE VOID**
   - Audio starts on user gesture
   - Realtime subscription begins

## Message format expected
Broadcast payload should contain:

```json
{
  "right": { "tracked": true, "wrist": [x, y, z] },
  "left":  { "tracked": false, "wrist": [x, y, z] }
}

## Supabase note (Snapcloud)
This project uses a Supabase-compatible service routed via Snapcloud, so the URL looks like:

`https://<project-ref>.snapcloud.dev`

This is expected. Do not replace it with `*.supabase.co` unless you are migrating to vanilla Supabase.
