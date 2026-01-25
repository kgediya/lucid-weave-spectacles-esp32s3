// AirMusic_SupabaseStream.js
// Streams continuous realtime control data via Snap Cloud (Supabase)
//
// ✅ Uses Supabase Realtime (Broadcast)
// ✅ No manual reconnect logic (Supabase handles this)
// ✅ Maintains all AirMusic logic (wristRot + compact joints)

import { createClient } from 'SupabaseClient.lspkg/supabase-snapcloud';

//@input Asset.SupabaseProject supabaseProject
//
// Two trackers (one per hand):
//@input Component.ObjectTracking3D leftObjectTracking3D
//@input Component.ObjectTracking3D rightObjectTracking3D
//
// Rig roots:
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig
//
// Tuning:
//@input float sendHz = 45
//@input float pinchThresholdM = 0.03
//@input bool debugLogs = false
//
// Joint streaming knobs:
//@input bool sendJoints = true
//@input float jointsHz = 15
//@input int jointsQuantizeMM = 2 
//@input bool sendJointRotations = false

// --- Supabase State ---
var client = null;
var channel = null;
var isSubscribed = false;

// --- AirMusic Tracking State ---
var leftTracking = false;
var rightTracking = false;
var nextSendTime = 0;
var leftResolved = false;
var rightResolved = false;
var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;
var leftJoints = [];
var rightJoints = [];
var resolveAttempts = 0;
var maxResolveAttempts = 240;
var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;
var nextJointsSendTime = 0;

function log(s) { if (script.debugLogs) print("[AirMusic] " + s); }

function onAwake() {
    bindTrackers();
    initSupabase();

    script.createEvent("UpdateEvent").bind(onUpdate);
}

async function initSupabase() {
    log("Initializing Snap Cloud...");
    
    const options = {
        realtime: { heartbeatIntervalMs: 2500 } // Essential Alpha Fix
    };

    client = createClient(
        script.supabaseProject.url, 
        script.supabaseProject.publicToken, 
        options
    );

    // Snap Cloud requires a session
    await client.auth.signInWithIdToken({ provider: 'snapchat', token: '' });

    // Join the relay channel
    channel = client.channel('air-music', {
        config: { broadcast: { self: false, ack: false } }
    });

    channel.subscribe(function(status) {
        if (status === 'SUBSCRIBED') {
            isSubscribed = true;
            log("✅ Channel Subscribed - Ready to stream");
        }
    });
}

function bindTrackers() {
    if (script.leftObjectTracking3D) {
        script.leftObjectTracking3D.onTrackingStarted = function () {
            leftTracking = true; leftResolved = false; resolveAttempts = 0;
            broadcast({ type: "tracking", hand: "L", state: "started" });
        };
        script.leftObjectTracking3D.onTrackingLost = function () {
            leftTracking = false;
            broadcast({ type: "tracking", hand: "L", state: "lost" });
        };
    }
    if (script.rightObjectTracking3D) {
        script.rightObjectTracking3D.onTrackingStarted = function () {
            rightTracking = true; rightResolved = false; resolveAttempts = 0;
            broadcast({ type: "tracking", hand: "R", state: "started" });
        };
        script.rightObjectTracking3D.onTrackingLost = function () {
            rightTracking = false;
            broadcast({ type: "tracking", hand: "R", state: "lost" });
        };
    }
}

function onUpdate() {
    var now = getTime();
    if (!isSubscribed || !channel) return;

    // Throttle controls
    var interval = 1.0 / Math.max(script.sendHz, 1);
    if (now < nextSendTime) return;
    nextSendTime = now + interval;

    var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
    prevTimeS = now;

    // Resolve joints
    if (resolveAttempts < maxResolveAttempts) {
        resolveAttempts++;
        if (leftTracking && !leftResolved && script.leftHandRig) resolveLeft();
        if (rightTracking && !rightResolved && script.rightHandRig) resolveRight();
    }

    var left = buildCompactHand("L", leftTracking, leftResolved, leftWrist, leftThumbTip, leftIndexTip, dt);
    var right = buildCompactHand("R", rightTracking, rightResolved, rightWrist, rightThumbTip, rightIndexTip, dt);

    var lead = (right.tracked ? "R" : (left.tracked ? "L" : "none"));
    var leadHand = (lead === "R") ? right : (lead === "L") ? left : null;

    // Synth logic
    var pitchN = 0.5;
    if (leadHand && leadHand.wrist) {
        pitchN = clamp01((leadHand.wrist[1] - 0.8) / 0.8);
    }

    var payload = {
        type: "controls",
        t: now,
        lead: lead,
        left: left,
        right: right,
        music: { pitchN: pitchN, intensity: clamp01((leadHand ? leadHand.speedMps : 0) / 2.0), pinch: (leadHand ? leadHand.pinchStrength : 0) }
    };

    // Joint throttling
    if (script.sendJoints && now >= nextJointsSendTime) {
        nextJointsSendTime = now + (1.0 / Math.max(script.jointsHz, 1));
        payload.joints = {
            q: script.jointsQuantizeMM,
            left: leftResolved ? packQuantizedPositionsMM(leftJoints, script.jointsQuantizeMM) : null,
            right: rightResolved ? packQuantizedPositionsMM(rightJoints, script.jointsQuantizeMM) : null
        };
    }

    broadcast(payload);
}

function broadcast(payload) {
    if (!channel || !isSubscribed) return;
    channel.send({
        type: 'broadcast',
        event: 'controls', // This replaces your /ws vs /out routing
        payload: payload
    });
}

/* --- Keep all your existing Helper Functions below (resolveHand, packQuantizedPositionsMM, etc.) --- */
// (Insert findByNameRecursiveSafe, buildCompactHand, etc. here from your original script)

onAwake();