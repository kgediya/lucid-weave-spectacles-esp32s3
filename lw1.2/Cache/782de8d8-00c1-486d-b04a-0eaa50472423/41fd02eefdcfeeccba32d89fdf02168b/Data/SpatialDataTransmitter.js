// AirMusic_HandStream_TwoTrackersSafe.js

//@input Asset.InternetModule internetModule
//@input string wsUrl = "wss://YOUR_SERVER_URL"

// Rig roots (drag LeftHandRig / RightHandRig)
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig

// Two trackers (one per hand)
//@input Component.ObjectTracking3D leftObjectTracking3D
//@input Component.ObjectTracking3D rightObjectTracking3D

//@input float sendHz = 15
//@input float pinchThresholdM = 0.03
//@input bool includeRotations = false

// 0 = Compact (recommended), 1 = Full
//@input int sendMode = 0

//@input bool debugLogs = true

// ------------ Internal state ------------
var socket = null;
var isOpen = false;

var leftTracking = false;
var rightTracking = false;

// prevent spamming tracking-lost status
var leftLostSent = false;
var rightLostSent = false;

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;

// Resolved joints
var leftResolved = false;
var rightResolved = false;

var leftJoints = [];
var rightJoints = [];

var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;

// resolve attempts (hands may initialize late)
var resolveAttempts = 0;
var maxResolveAttempts = 240;

function log(s) { if (script.debugLogs) print(s); }

function onAwake() {
  if (!script.internetModule) { print("[AirMusic] ❌ Missing InternetModule"); return; }

  bindTrackingEvents();
  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
}

function bindTrackingEvents() {
  // LEFT
  if (script.leftObjectTracking3D) {
    leftTracking = false;
    script.leftObjectTracking3D.onTrackingStarted = function () {
      leftTracking = true;
      leftLostSent = false;
      leftResolved = false; // re-resolve joints when tracking starts
      log("[AirMusic] ✅ LEFT tracking started");
      safeSendJSON({ type: "tracking", hand: "L", state: "started", t: getTime() });
    };
    script.leftObjectTracking3D.onTrackingLost = function () {
      leftTracking = false;
      leftResolved = false;
      prevLeftWristPos = null;
      log("[AirMusic] ❌ LEFT tracking lost");
      safeSendJSON({ type: "tracking", hand: "L", state: "lost", t: getTime() });
    };
  } else {
    print("[AirMusic] ⚠️ leftObjectTracking3D not set (left hand ungated)");
    leftTracking = true;
  }

  // RIGHT
  if (script.rightObjectTracking3D) {
    rightTracking = false;
    script.rightObjectTracking3D.onTrackingStarted = function () {
      rightTracking = true;
      rightLostSent = false;
      rightResolved = false;
      log("[AirMusic] ✅ RIGHT tracking started");
      safeSendJSON({ type: "tracking", hand: "R", state: "started", t: getTime() });
    };
    script.rightObjectTracking3D.onTrackingLost = function () {
      rightTracking = false;
      rightResolved = false;
      prevRightWristPos = null;
      log("[AirMusic] ❌ RIGHT tracking lost");
      safeSendJSON({ type: "tracking", hand: "R", state: "lost", t: getTime() });
    };
  } else {
    // If you truly only track one hand, this is fine.
    // print("[AirMusic] ⚠️ rightObjectTracking3D not set (right hand ungated)");
    rightTracking = true;
  }
}

function connect() {
  try {
    log("[AirMusic] Connecting WS: " + script.wsUrl);

    socket = script.internetModule.createWebSocket(script.wsUrl);
    socket.binaryType = "blob";

    socket.onopen = function () {
      isOpen = true;
      reconnectAttempt = 0;
      log("[AirMusic] WebSocket Connected ✅");
      safeSendJSON({ type: "hello", app: "AirMusic", t: getTime() });
    };

    socket.onclose = function (e) {
      isOpen = false;
      log("[AirMusic] WS Closed. code=" + e.code + " clean=" + e.wasClean);
      scheduleReconnect();
    };

    socket.onerror = function () {
      isOpen = false;
      log("[AirMusic] WS Error");
      scheduleReconnect();
    };
  } catch (err) {
    isOpen = false;
    print("[AirMusic] WS connect failed: " + err);
    scheduleReconnect();
  }
}

function scheduleReconnect() {
  var delay = Math.min(0.5 * Math.pow(2, reconnectAttempt), 8.0);
  reconnectAttempt += 1;
  reconnectAtTime = getTime() + delay;
  log("[AirMusic] Reconnect in " + delay.toFixed(1) + "s...");
}

function onUpdate() {
  var now = getTime();

  // reconnect if needed
  if (!isOpen && reconnectAtTime > 0 && now >= reconnectAtTime) {
    reconnectAtTime = 0;
    connect();
  }

  // throttle
  var interval = 1.0 / Math.max(script.sendHz, 1);
  if (now < nextSendTime) return;
  nextSendTime = now + interval;

  if (!socket || !isOpen) return;

  // Attempt resolving while tracking is active (hands may appear later)
  if (resolveAttempts < maxResolveAttempts) {
    resolveAttempts++;
    if (leftTracking && !leftResolved && script.leftHandRig) resolveLeft();
    if (rightTracking && !rightResolved && script.rightHandRig) resolveRight();
  }

  // Build per-hand packets safely (only if tracking + resolved)
  var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
  prevTimeS = now;

  var leftPacket = makeHandOrStatus("L", leftTracking, leftResolved, leftJoints, leftWrist, leftThumbTip, leftIndexTip, dt);
  var rightPacket = makeHandOrStatus("R", rightTracking, rightResolved, rightJoints, rightWrist, rightThumbTip, rightIndexTip, dt);

  // Send combined frame (same schema your server expects)
  safeSendJSON({
    type: "handFrame",
    t: now,
    dt: dt,
    left: leftPacket,
    right: rightPacket
  });
}

function resolveLeft() {
  var L = resolveHand(script.leftHandRig);
  if (isHandResolved(L)) {
    leftJoints = L.joints;
    leftWrist = L.wrist;
    leftThumbTip = L.thumbTip;
    leftIndexTip = L.indexTip;
    leftResolved = true;
    log("[AirMusic] ✅ Left joints resolved: " + leftJoints.length);
    safeSendJSON({ type: "resolved", hand: "L", jointCount: leftJoints.length });
  }
}

function resolveRight() {
  var R = resolveHand(script.rightHandRig);
  if (isHandResolved(R)) {
    rightJoints = R.joints;
    rightWrist = R.wrist;
    rightThumbTip = R.thumbTip;
    rightIndexTip = R.indexTip;
    rightResolved = true;
    log("[AirMusic] ✅ Right joints resolved: " + rightJoints.length);
    safeSendJSON({ type: "resolved", hand: "R", jointCount: rightJoints.length });
  }
}

function makeHandOrStatus(label, tracking, resolved, joints, wristSO, thumbTipSO, indexTipSO, dt) {
  // If not tracking: send minimal status
  if (!tracking) {
    return { tracked: false, tracking: false, pinchStrength: 0, speedMps: 0, wrist: null };
  }

  // Tracking but joints not resolved yet
  if (!resolved) {
    return { tracked: false, tracking: true, pinchStrength: 0, speedMps: 0, wrist: null, note: "waiting_for_joints" };
  }

  // Normal packet
  var pkt = buildHandPacket(label, joints, wristSO, thumbTipSO, indexTipSO, dt);
  return (script.sendMode === 0) ? pkt.compact : pkt.full;
}

function isHandResolved(H) {
  return H && H.joints && H.joints.length > 0 && H.wrist && H.thumbTip && H.indexTip;
}

function resolveHand(rigRoot) {
  var wrist = findByNameRecursiveSafe(rigRoot, "wrist");

  var thumb0 = findByNameRecursiveSafe(rigRoot, "thumb-0");
  var thumb1 = findByNameRecursiveSafe(rigRoot, "thumb-1");
  var thumb2 = findByNameRecursiveSafe(rigRoot, "thumb-2");
  var thumb3 = findByNameRecursiveSafe(rigRoot, "thumb-3");
  var thumb3end = findByNameRecursiveSafe(rigRoot, "thumb-3_end");

  var index0 = findByNameRecursiveSafe(rigRoot, "index-0");
  var index1 = findByNameRecursiveSafe(rigRoot, "index-1");
  var index2 = findByNameRecursiveSafe(rigRoot, "index-2");
  var index3 = findByNameRecursiveSafe(rigRoot, "index-3");
  var index3end = findByNameRecursiveSafe(rigRoot, "index-3_end");

  var joints = [];
  pushIf(joints, wrist);
  pushIf(joints, thumb0); pushIf(joints, thumb1); pushIf(joints, thumb2); pushIf(joints, thumb3); pushIf(joints, thumb3end);
  pushIf(joints, index0); pushIf(joints, index1); pushIf(joints, index2); pushIf(joints, index3); pushIf(joints, index3end);

  return { joints: joints, wrist: wrist, thumbTip: thumb3, indexTip: index3 };
}

function buildHandPacket(label, joints, wristSO, thumbTipSO, indexTipSO, dt) {
  var tracked = joints && joints.length > 0;

  var pinchStrength = 0;
  if (thumbTipSO && indexTipSO) {
    var a = safeWorldPos(thumbTipSO);
    var b = safeWorldPos(indexTipSO);
    if (a && b) {
      var d = a.distance(b);
      pinchStrength = clamp01(1.0 - (d / Math.max(script.pinchThresholdM, 1e-4)));
    }
  }

  var speed = 0;
  var wristArr = null;

  if (wristSO) {
    var w = safeWorldPos(wristSO);
    if (w) {
      wristArr = [w.x, w.y, w.z];
      if (label === "L") {
        if (prevLeftWristPos) speed = w.distance(prevLeftWristPos) / dt;
        prevLeftWristPos = w;
      } else {
        if (prevRightWristPos) speed = w.distance(prevRightWristPos) / dt;
        prevRightWristPos = w;
      }
    }
  }

  var compact = {
    tracked: tracked,
    tracking: true,
    pinchStrength: pinchStrength,
    speedMps: speed,
    wrist: wristArr
  };

  // Full arrays (optional)
  var positions = [];
  var rotations = [];

  if (tracked) {
    for (var i = 0; i < joints.length; i++) {
      var so = joints[i];
      var p = safeWorldPos(so);
      if (!p || !isFinite3(p)) positions.push(0, 0, 0);
      else positions.push(p.x, p.y, p.z);

      if (script.includeRotations) {
        var r = safeWorldRot(so);
        if (!r || !isFiniteQuat(r)) rotations.push(0, 0, 0, 1);
        else rotations.push(r.x, r.y, r.z, r.w);
      }
    }
  }

  var full = {
    tracked: tracked,
    tracking: true,
    jointCount: joints ? joints.length : 0,
    positions: positions,
    rotations: script.includeRotations ? rotations : undefined,
    pinchStrength: pinchStrength,
    speedMps: speed,
    wrist: wristArr
  };

  return { compact: compact, full: full };
}

function pushIf(arr, so) { if (so) arr.push(so); }

function findByNameRecursiveSafe(root, name) {
  try {
    if (!root) return null;
    if (root.name === name) return root;

    var n = root.getChildrenCount ? root.getChildrenCount() : 0;
    for (var i = 0; i < n; i++) {
      var child = root.getChild(i);
      var found = findByNameRecursiveSafe(child, name);
      if (found) return found;
    }
    return null;
  } catch (_e) {
    return null;
  }
}

function safeWorldPos(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldPosition();
  } catch (_e) { return null; }
}

function safeWorldRot(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldRotation();
  } catch (_e) { return null; }
}

function isFinite3(v) { return isFinite(v.x) && isFinite(v.y) && isFinite(v.z); }
function isFiniteQuat(q) { return isFinite(q.x) && isFinite(q.y) && isFinite(q.z) && isFinite(q.w); }

function safeSendJSON(obj) {
  if (!socket || !isOpen) return;
  try {
    socket.send(JSON.stringify(obj));
  } catch (e) {
    // Keep minimal logging to avoid crash-by-spam
    print("[AirMusic] send failed: " + e);
  }
}

function clamp01(v) { return Math.max(0, Math.min(1, v)); }

onAwake();
