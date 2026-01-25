// AirMusic_SupabaseStream.js
// Streams continuous realtime control data via Snap Cloud (Supabase)
// Fixed for Lens Studio JS (CommonJS)

const { createClient } = require('SupabaseClient.lspkg/supabase-snapcloud');

//@input Asset.SupabaseProject supabaseProject
//@ui {"widget":"separator"}
//@input Component.ObjectTracking3D leftObjectTracking3D
//@input Component.ObjectTracking3D rightObjectTracking3D
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig
//@ui {"widget":"separator"}
//@input float sendHz = 45
//@input float pinchThresholdM = 0.03
//@input bool debugLogs = false
//@ui {"widget":"separator"}
//@input bool sendJoints = true
//@input float jointsHz = 15
//@input int jointsQuantizeMM = 2 
//@input bool sendJointRotations = false

// --- Supabase State ---
var client = null;
var channel = null;
var isSubscribed = false;

// --- Tracking State ---
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
    if (!script.supabaseProject) {
        print("❌ ERROR: Assign SupabaseProject in the Inspector!");
        return;
    }
    bindTrackers();
    initSupabase();
    script.createEvent("UpdateEvent").bind(onUpdate);
}

async function initSupabase() {
    log("Initializing Snap Cloud...");
    
    var options = {
        realtime: { heartbeatIntervalMs: 2500 } // Essential Alpha Fix
    };

    client = createClient(
        script.supabaseProject.url, 
        script.supabaseProject.publicToken, 
        options
    );

    // Auth is required for Realtime
    try {
        await client.auth.signInWithIdToken({ provider: 'snapchat', token: '' });
        
        // Join the channel
        channel = client.channel('air-music', {
            config: { broadcast: { self: false, ack: false } }
        });

        channel.subscribe(function(status) {
            if (status === 'SUBSCRIBED') {
                isSubscribed = true;
                log("✅ Connected to Supabase Relay");
            }
        });
    } catch (e) {
        print("❌ Auth Error: " + e);
    }
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

    var interval = 1.0 / Math.max(script.sendHz, 1);
    if (now < nextSendTime) return;
    nextSendTime = now + interval;

    var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
    prevTimeS = now;

    if (resolveAttempts < maxResolveAttempts) {
        resolveAttempts++;
        if (leftTracking && !leftResolved && script.leftHandRig) resolveLeft();
        if (rightTracking && !rightResolved && script.rightHandRig) resolveRight();
    }

    var left = buildCompactHand("L", leftTracking, leftResolved, leftWrist, leftThumbTip, leftIndexTip, dt);
    var right = buildCompactHand("R", rightTracking, rightResolved, rightWrist, rightThumbTip, rightIndexTip, dt);

    var lead = (right.tracked ? "R" : (left.tracked ? "L" : "none"));
    var leadHand = (lead === "R") ? right : (lead === "L") ? left : null;

    var pitchN = 0.5;
    if (leadHand && leadHand.wrist) {
        var minY = 0.8, maxY = 1.6;
        pitchN = clamp01((leadHand.wrist[1] - minY) / (maxY - minY));
    }

    var payload = {
        type: "controls",
        t: now,
        lead: lead,
        left: left,
        right: right,
        music: { 
            pitchN: pitchN, 
            intensity: clamp01((leadHand ? leadHand.speedMps : 0) / 2.0), 
            pinch: (leadHand ? leadHand.pinchStrength : 0) 
        }
    };

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
        event: 'controls',
        payload: payload
    });
}

/* ---------------- Joint resolution logic ---------------- */

function resolveLeft() {
    var H = resolveHand(script.leftHandRig);
    if (H) {
        leftWrist = H.wrist; leftThumbTip = H.thumbTip; leftIndexTip = H.indexTip;
        leftJoints = H.joints; leftResolved = true;
        log("✅ Left joints resolved");
    }
}

function resolveRight() {
    var H = resolveHand(script.rightHandRig);
    if (H) {
        rightWrist = H.wrist; rightThumbTip = H.thumbTip; rightIndexTip = H.indexTip;
        rightJoints = H.joints; rightResolved = true;
        log("✅ Right joints resolved");
    }
}

function resolveHand(rigRoot) {
    var wrist = findByNameRecursiveSafe(rigRoot, "wrist");
    var thumb3 = findByNameRecursiveSafe(rigRoot, "thumb-3");
    var index3 = findByNameRecursiveSafe(rigRoot, "index-3");
    if (!wrist || !thumb3 || !index3) return null;

    var joints = [];
    pushIf(joints, wrist);
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-0"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-1"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-2"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-3"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-0"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-1"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-2"));
    pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-3"));
    return { wrist: wrist, thumbTip: thumb3, indexTip: index3, joints: joints };
}

function buildCompactHand(label, tracking, resolved, wristSO, thumbTipSO, indexTipSO, dt) {
    if (!tracking || !resolved) return { tracked: false };
    
    var wristPos = safeWorldPos(wristSO);
    var wristRot = safeWorldRot(wristSO);
    var speed = 0;

    if (wristPos) {
        var prev = (label === "L") ? prevLeftWristPos : prevRightWristPos;
        if (prev) speed = wristPos.distance(prev) / dt;
        if (label === "L") prevLeftWristPos = wristPos; else prevRightWristPos = wristPos;
    }

    var pinch = 0;
    var a = safeWorldPos(thumbTipSO);
    var b = safeWorldPos(indexTipSO);
    if (a && b) pinch = clamp01(1.0 - (a.distance(b) / Math.max(script.pinchThresholdM, 1e-4)));

    return {
        tracked: true,
        wrist: wristPos ? [wristPos.x, wristPos.y, wristPos.z] : null,
        wristRot: wristRot ? [wristRot.x, wristRot.y, wristRot.z, wristRot.w] : null,
        speedMps: speed,
        pinchStrength: pinch
    };
}

/* ---------------- Utils ---------------- */

function packQuantizedPositionsMM(joints, qMM) {
    var step = Math.max(1, Math.floor(qMM));
    var out = [];
    for (var i = 0; i < joints.length; i++) {
        var p = safeWorldPos(joints[i]);
        if (!p) { out.push(0, 0, 0); continue; }
        out.push(Math.round((p.x * 1000) / step) * step, Math.round((p.y * 1000) / step) * step, Math.round((p.z * 1000) / step) * step);
    }
    return out;
}

function findByNameRecursiveSafe(root, name) {
    if (!root) return null;
    if (root.name === name) return root;
    for (var i = 0; i < root.getChildrenCount(); i++) {
        var found = findByNameRecursiveSafe(root.getChild(i), name);
        if (found) return found;
    }
    return null;
}

function pushIf(arr, so) { if (so) arr.push(so); }
function safeWorldPos(so) { return so ? so.getTransform().getWorldPosition() : null; }
function safeWorldRot(so) { return so ? so.getTransform().getWorldRotation() : null; }
function clamp01(v) { return Math.max(0, Math.min(1, v)); }

onAwake();