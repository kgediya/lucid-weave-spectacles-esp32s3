// AirMusic_HandStream_SafeDebug.js
//@input Asset.InternetModule internetModule
//@input string wsUrl = "wss://YOUR_SERVER_URL"

// Drag rig roots: LeftHandModel -> LeftHandRig (same for RightHandRig)
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig

//@input float sendHz = 15
//@input float pinchThresholdM = 0.03
//@input bool includeRotations = false

// 0 = Compact (recommended for debugging), 1 = Full (positions array)
//@input int sendMode = 0

//@input bool debugLogs = true
//@input bool debugOnce = true
//@input bool debugShowStats = true

// ------------ Internal state ------------
var socket = null;
var isOpen = false;

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;

var resolved = false;
var resolveAttempts = 0;
var maxResolveAttempts = 120; // ~2 seconds at 60fps

// Resolved joints (stable order)
var leftJoints = [];
var rightJoints = [];

var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;

// Debug stats
var frameCount = 0;
var sentCount = 0;
var lastStatsTime = 0;

function log(s) {
  if (script.debugLogs) print(s);
}

function onAwake() {
  if (!script.internetModule) {
    print("[AirMusic] ❌ Missing InternetModule input.");
    return;
  }

  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
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
  frameCount++;
  var now = getTime();

  // show stats occasionally
  if (script.debugShowStats && (now - lastStatsTime) > 2.0) {
    lastStatsTime = now;
    log("[AirMusic] stats: frames=" + frameCount + " sent=" + sentCount + " resolved=" + resolved);
  }

  // Attempt to resolve joints safely for a short period
  if (!resolved && resolveAttempts < maxResolveAttempts) {
    resolveAttempts++;
    tryResolveJoints();
  }

  // Reconnect if needed
  if (!isOpen && reconnectAtTime > 0 && now >= reconnectAtTime) {
    reconnectAtTime = 0;
    connect();
  }

  // Throttle sends
  var interval = 1.0 / Math.max(script.sendHz, 1);
  if (now < nextSendTime) return;
  nextSendTime = now + interval;

  if (!socket || !isOpen) return;

  // If we aren't resolved yet, still send a heartbeat to confirm connectivity
  if (!resolved) {
    safeSendJSON({ type: "heartbeat", t: now, note: "waiting_for_joints" });
    sentCount++;
    return;
  }

  try {
    var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
    prevTimeS = now;

    var left = buildHandPacket("L", leftJoints, leftWrist, leftThumbTip, leftIndexTip, dt);
    var right = buildHandPacket("R", rightJoints, rightWrist, rightThumbTip, rightIndexTip, dt);

    // Compact send mode: avoids huge arrays (best for crash-debug)
    if (script.sendMode === 0) {
      var payloadCompact = {
        type: "handFrame",
        t: now,
        dt: dt,
        left: left.compact,
        right: right.compact
      };
      safeSendJSON(payloadCompact);
      sentCount++;
      return;
    }

    // Full send mode (positions arrays)
    var payloadFull = {
      type: "handFrame",
      t: now,
      dt: dt,
      left: left.full,
      right: right.full
    };

    safeSendJSON(payloadFull);
    sentCount++;
  } catch (e) {
    // Prevent hard crash; log once
    if (script.debugOnce) {
      print("[AirMusic] ❌ onUpdate error: " + e);
      script.debugOnce = false;
    }
  }
}

function tryResolveJoints() {
  // Only attempt if rigs exist
  if (!script.leftHandRig && !script.rightHandRig) return;

  var didResolveAny = false;

  if (script.leftHandRig) {
    var L = resolveHand(script.leftHandRig);
    if (L && L.joints.length > 0 && L.wrist && L.thumbTip && L.indexTip) {
      leftJoints = L.joints;
      leftWrist = L.wrist;
      leftThumbTip = L.thumbTip;
      leftIndexTip = L.indexTip;
      didResolveAny = true;
      log("[AirMusic] ✅ Left joints resolved: " + leftJoints.length);
    }
  }

  if (script.rightHandRig) {
    var R = resolveHand(script.rightHandRig);
    if (R && R.joints.length > 0 && R.wrist && R.thumbTip && R.indexTip) {
      rightJoints = R.joints;
      rightWrist = R.wrist;
      rightThumbTip = R.thumbTip;
      rightIndexTip = R.indexTip;
      didResolveAny = true;
      log("[AirMusic] ✅ Right joints resolved: " + rightJoints.length);
    }
  }

  // Mark resolved if we have at least one hand working
  if (didResolveAny) {
    resolved = true;
    safeSendJSON({
      type: "resolved",
      leftCount: leftJoints.length,
      rightCount: rightJoints.length
    });
  }
}

function resolveHand(rigRoot) {
  // Stable pinch joints for your hierarchy:
  // wrist, thumb-3, index-3
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
  pushIf(joints, thumb0);
  pushIf(joints, thumb1);
  pushIf(joints, thumb2);
  pushIf(joints, thumb3);
  pushIf(joints, thumb3end);
  pushIf(joints, index0);
  pushIf(joints, index1);
  pushIf(joints, index2);
  pushIf(joints, index3);
  pushIf(joints, index3end);

  return {
    joints: joints,
    wrist: wrist,
    thumbTip: thumb3,
    indexTip: index3
  };
}

function pushIf(arr, so) {
  if (so) arr.push(so);
}

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
  } catch (e) {
    return null;
  }
}

// Returns { full, compact }
function buildHandPacket(label, joints, wristSO, thumbTipSO, indexTipSO, dt) {
  var tracked = joints && joints.length > 0;

  // Compact essentials
  var pinchStrength = 0;
  var speed = 0;
  var wristPos = null;

  // Compute pinch
  if (thumbTipSO && indexTipSO) {
    var a = safeWorldPos(thumbTipSO);
    var b = safeWorldPos(indexTipSO);
    if (a && b) {
      var d = a.distance(b);
      pinchStrength = clamp01(1.0 - (d / Math.max(script.pinchThresholdM, 1e-4)));
    }
  }

  // Wrist speed
  if (wristSO) {
    var w = safeWorldPos(wristSO);
    wristPos = w;
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
    wrist: wristPos ? [wristPos.x, wristPos.y, wristPos.z] : null
  };

  // Full payload only if asked (and safe numbers only)
  var positions = [];
  var rotations = [];

  if (tracked) {
    for (var i = 0; i < joints.length; i++) {
      var so = joints[i];
      if (!so) {
        positions.push(0, 0, 0);
        if (script.includeRotations) rotations.push(0, 0, 0, 1);
        continue;
      }

      var p = safeWorldPos(so);
      if (!p || !isFinite3(p)) {
        // avoid NaNs killing JSON or server
        positions.push(0, 0, 0);
      } else {
        positions.push(p.x, p.y, p.z);
      }

      if (script.includeRotations) {
        var r = safeWorldRot(so);
        if (!r || !isFiniteQuat(r)) {
          rotations.push(0, 0, 0, 1);
        } else {
          rotations.push(r.x, r.y, r.z, r.w);
        }
      }
    }
  }

  var full = {
    tracked: tracked,
    jointCount: joints ? joints.length : 0,
    positions: positions,
    rotations: script.includeRotations ? rotations : undefined,
    pinchStrength: pinchStrength,
    speedMps: speed
  };

  return { compact: compact, full: full };
}

function safeWorldPos(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldPosition();
  } catch (e) {
    return null;
  }
}

function safeWorldRot(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldRotation();
  } catch (e) {
    return null;
  }
}

function isFinite3(v) {
  return isFinite(v.x) && isFinite(v.y) && isFinite(v.z);
}

function isFiniteQuat(q) {
  return isFinite(q.x) && isFinite(q.y) && isFinite(q.z) && isFinite(q.w);
}

function safeSendJSON(obj) {
  if (!socket || !isOpen) return;
  try {
    socket.send(JSON.stringify(obj));
  } catch (e) {
    if (script.debugOnce) {
      print("[AirMusic] ❌ send failed: " + e);
      script.debugOnce = false;
    }
  }
}

function clamp01(v) {
  return Math.max(0, Math.min(1, v));
}

onAwake();
