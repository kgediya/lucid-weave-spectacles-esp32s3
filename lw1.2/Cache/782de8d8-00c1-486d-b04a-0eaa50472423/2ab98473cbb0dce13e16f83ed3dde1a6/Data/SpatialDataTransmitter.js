// AirMusic_HandStream_ObjectTrackingSafe.js

//@input Asset.InternetModule internetModule
//@input string wsUrl = "wss://YOUR_SERVER_URL"

// Hand rig roots (drag LeftHandRig / RightHandRig)
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig

// ObjectTracking3D component from the 3D Hand Tracking template
//@input Component.ObjectTracking3D objectTracking3D

//@input float sendHz = 15
//@input float pinchThresholdM = 0.03
//@input bool includeRotations = false

// 0 = Compact (debug safe), 1 = Full
//@input int sendMode = 0

//@input bool debugLogs = true

// ------------ Internal state ------------
var socket = null;
var isOpen = false;

var trackingActive = false;   // ✅ gated by ObjectTracking3D callbacks
var sentTrackingLost = false; // ensures we don't spam

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;

var resolved = false;
var resolveAttempts = 0;
var maxResolveAttempts = 240; // allow a few seconds

var leftJoints = [];
var rightJoints = [];
var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;

function log(s) { if (script.debugLogs) print(s); }

function onAwake() {
  if (!script.internetModule) { print("[AirMusic] ❌ Missing InternetModule"); return; }

  bindObjectTrackingEvents();
  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
}

function bindObjectTrackingEvents() {
  if (!script.objectTracking3D) {
    print("[AirMusic] ⚠️ objectTracking3D not set. Tracking gate disabled.");
    trackingActive = true; // fallback: allow sends if they didn't wire it
    return;
  }

  // Start gated OFF until started
  trackingActive = false;

  script.objectTracking3D.onTrackingStarted = function () {
    trackingActive = true;
    sentTrackingLost = false;
    log("[AirMusic] ✅ ObjectTracking3D Started Tracking");

    // Try resolving joints again when tracking starts
    resolved = false;
    resolveAttempts = 0;

    safeSendJSON({ type: "tracking", state: "started", t: getTime() });
  };

  script.objectTracking3D.onTrackingLost = function () {
    trackingActive = false;
    log("[AirMusic] ❌ ObjectTracking3D Lost Tracking");

    // Optional: clear previous wrist positions so speed doesn’t spike on resume
    prevLeftWristPos = null;
    prevRightWristPos = null;

    safeSendJSON({ type: "tracking", state: "lost", t: getTime() });
  };
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

  // ✅ FAIL-SAFE: if tracking isn't active, do not send heavy data
  if (!trackingActive) {
    if (!sentTrackingLost) {
      sentTrackingLost = true;
      safeSendJSON({ type: "status", t: now, tracking: false, note: "tracking_inactive" });
    }
    return;
  }

  // Try to resolve joints once tracking is active
  if (!resolved && resolveAttempts < maxResolveAttempts) {
    resolveAttempts++;
    tryResolveJoints();
  }

  if (!resolved) {
    safeSendJSON({ type: "status", t: now, tracking: true, note: "waiting_for_joints" });
    return;
  }

  var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
  prevTimeS = now;

  var left = buildHandPacket("L", leftJoints, leftWrist, leftThumbTip, leftIndexTip, dt);
  var right = buildHandPacket("R", rightJoints, rightWrist, rightThumbTip, rightIndexTip, dt);

  // Compact mode (safer)
  if (script.sendMode === 0) {
    safeSendJSON({
      type: "handFrame",
      t: now,
      dt: dt,
      left: left.compact,
      right: right.compact
    });
    return;
  }

  // Full mode
  safeSendJSON({
    type: "handFrame",
    t: now,
    dt: dt,
    left: left.full,
    right: right.full
  });
}

function tryResolveJoints() {
  var didResolve = false;

  if (script.leftHandRig) {
    var L = resolveHand(script.leftHandRig);
    if (isHandResolved(L)) {
      leftJoints = L.joints;
      leftWrist = L.wrist;
      leftThumbTip = L.thumbTip;
      leftIndexTip = L.indexTip;
      didResolve = true;
      log("[AirMusic] ✅ Left joints resolved: " + leftJoints.length);
    }
  }

  if (script.rightHandRig) {
    var R = resolveHand(script.rightHandRig);
    if (isHandResolved(R)) {
      rightJoints = R.joints;
      rightWrist = R.wrist;
      rightThumbTip = R.thumbTip;
      rightIndexTip = R.indexTip;
      didResolve = true;
      log("[AirMusic] ✅ Right joints resolved: " + rightJoints.length);
    }
  }

  // resolved if at least one hand works
  if (didResolve) {
    resolved = true;
    safeSendJSON({ type: "resolved", leftCount: leftJoints.length, rightCount: rightJoints.length });
  }
}

function isHandResolved(H) {
  return H && H.joints && H.joints.length > 0 && H.wrist && H.thumbTip && H.indexTip;
}

function resolveHand(rigRoot) {
  // From your hierarchy: use wrist, thumb-3, index-3
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

function buildHandPacket(label, joints, wristSO, thumbTipSO, indexTipSO, dt) {
  var tracked = joints && joints.length > 0;

  // Pinch
  var pinchStrength = 0;
  if (thumbTipSO && indexTipSO) {
    var a = safeWorldPos(thumbTipSO);
    var b = safeWorldPos(indexTipSO);
    if (a && b) {
      var d = a.distance(b);
      pinchStrength = clamp01(1.0 - (d / Math.max(script.pinchThresholdM, 1e-4)));
    }
  }

  // Wrist speed + wrist pos
  var speed = 0;
  var wristPos = null;
  if (wristSO) {
    var w = safeWorldPos(wristSO);
    wristPos = w ? [w.x, w.y, w.z] : null;

    if (w) {
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
    pinchStrength: pinchStrength,
    speedMps: speed,
    wrist: wristPos,
    tracking: true
  };

  // Full arrays (optional)
  var positions = [];
  var rotations = [];

  if (tracked) {
    for (var i = 0; i < joints.length; i++) {
      var so = joints[i];
      var p = safeWorldPos(so);
      if (!p || !isFinite3(p)) {
        positions.push(0, 0, 0);
      } else {
        positions.push(p.x, p.y, p.z);
      }

      if (script.includeRotations) {
        var r = safeWorldRot(so);
        if (!r || !isFiniteQuat(r)) rotations.push(0, 0, 0, 1);
        else rotations.push(r.x, r.y, r.z, r.w);
      }
    }
  }

  var full = {
    tracked: tracked,
    jointCount: joints ? joints.length : 0,
    positions: positions,
    rotations: script.includeRotations ? rotations : undefined,
    pinchStrength: pinchStrength,
    speedMps: speed,
    tracking: true
  };

  return { compact: compact, full: full };
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
    // Keep quiet to avoid log spam crashes
    print("[AirMusic] send failed: " + e);
  }
}

function clamp01(v) { return Math.max(0, Math.min(1, v)); }

onAwake();
