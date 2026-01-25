// AirMusic_ContinuousStream.js (UPDATED)
// Streams continuous realtime control data PLUS wrist rotation + compact joints.
//
// Goals:
// ✅ Continuous stream for realtime synth (small+stable packet)
// ✅ Adds wrist rotation (quat) every frame
// ✅ Adds compact joint data efficiently (quantized + throttled)
// ✅ Two ObjectTracking3D (one per hand) fail-safe
//
// Requires:
//@input Asset.InternetModule internetModule
//@input string wsUrl = "ws://YOUR_SERVER_IP:8080/ws"
//
// Two trackers (one per hand):
//@input Component.ObjectTracking3D leftObjectTracking3D
//@input Component.ObjectTracking3D rightObjectTracking3D
//
// Rig roots (drag the hand rig roots from your hierarchy):
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
//@input float jointsHz = 15               // joints update rate (lower than controls)
//@input int jointsQuantizeMM = 2          // quantize positions in millimeters (2mm = good)
//@input bool sendJointRotations = false   // OFF by default (heavy)

var socket = null;
var isOpen = false;

var leftTracking = false;
var rightTracking = false;

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

// Resolved joints per hand (from your structure)
var leftResolved = false;
var rightResolved = false;

var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;

// compact joint list (wrist + thumb chain + index chain)
var leftJoints = [];
var rightJoints = [];

var resolveAttempts = 0;
var maxResolveAttempts = 240;

// velocity
var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;

// joints throttle
var nextJointsSendTime = 0;

function log(s) { if (script.debugLogs) print(s); }

function onAwake() {
  if (!script.internetModule) { print("[AirMusic] ❌ Missing InternetModule"); return; }
  bindTrackers();
  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
}

function bindTrackers() {
  // LEFT
  if (script.leftObjectTracking3D) {
    leftTracking = false;
    script.leftObjectTracking3D.onTrackingStarted = function () {
      leftTracking = true;
      leftResolved = false;
      resolveAttempts = 0;
      prevLeftWristPos = null;
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
    leftTracking = true;
  }

  // RIGHT
  if (script.rightObjectTracking3D) {
    rightTracking = false;
    script.rightObjectTracking3D.onTrackingStarted = function () {
      rightTracking = true;
      rightResolved = false;
      resolveAttempts = 0;
      prevRightWristPos = null;
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
    rightTracking = true;
  }
}

function connect() {
  try {
    log("[AirMusic] Connecting WS: " + script.wsUrl);
    socket = script.internetModule.createWebSocket(script.wsUrl);
    socket.binaryType = "blob"; // Lens limitation

    socket.onopen = function () {
      isOpen = true;
      reconnectAttempt = 0;
      log("[AirMusic] WebSocket Connected ✅");
      safeSendJSON({
        type: "hello",
        app: "AirMusic",
        mode: "continuous+rot+joints",
        t: getTime(),
        jointsHz: script.jointsHz,
        jointsQuantizeMM: script.jointsQuantizeMM
      });
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

  // Reconnect
  if (!isOpen && reconnectAtTime > 0 && now >= reconnectAtTime) {
    reconnectAtTime = 0;
    connect();
  }

  // Throttle controls
  var interval = 1.0 / Math.max(script.sendHz, 1);
  if (now < nextSendTime) return;
  nextSendTime = now + interval;

  if (!socket || !isOpen) return;

  // dt
  var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
  prevTimeS = now;

  // Resolve joints while tracking is active
  if (resolveAttempts < maxResolveAttempts) {
    resolveAttempts++;
    if (leftTracking && !leftResolved && script.leftHandRig) resolveLeft();
    if (rightTracking && !rightResolved && script.rightHandRig) resolveRight();
  }

  // Build per-hand compact state (includes wrist rot)
  var left = buildCompactHand("L", leftTracking, leftResolved, leftWrist, leftThumbTip, leftIndexTip, dt);
  var right = buildCompactHand("R", rightTracking, rightResolved, rightWrist, rightThumbTip, rightIndexTip, dt);

  // Choose lead (prefer R)
  var lead = (right.tracked ? "R" : (left.tracked ? "L" : "none"));
  var leadHand = (lead === "R") ? right : (lead === "L") ? left : null;

  // Derive synth-friendly params
  var pitchN = 0.5;
  if (leadHand && leadHand.wrist && isFinite(leadHand.wrist[1])) {
    var minY = 0.8, maxY = 1.6;
    pitchN = clamp01((leadHand.wrist[1] - minY) / (maxY - minY));
  }

  var speed = leadHand ? leadHand.speedMps : 0;
  var intensity = clamp01(speed / 2.0);
  var pinch = leadHand ? leadHand.pinchStrength : 0;

  // Joints throttling: only add when it's time
  var includeJoints = false;
  if (script.sendJoints) {
    var jointsInterval = 1.0 / Math.max(script.jointsHz, 1);
    if (now >= nextJointsSendTime) {
      nextJointsSendTime = now + jointsInterval;
      includeJoints = true;
    }
  }

  // Controls packet (continuous)
  // NOTE: joints are OPTIONAL and only included at jointsHz to keep bandwidth sane.
  var payload = {
    type: "controls",
    t: now,
    dt: dt,
    lead: lead,
    left: left,
    right: right,
    music: {
      pitchN: pitchN,
      intensity: intensity,
      pinch: pinch
    }
  };

  if (includeJoints) {
    payload.joints = {
      // quantized positions in millimeters (Int16-ish range but sent as ints in JSON)
      // decode: meters = mm / 1000
      q: script.jointsQuantizeMM, // quantization step in mm
      left: leftResolved ? packQuantizedPositionsMM(leftJoints, script.jointsQuantizeMM) : null,
      right: rightResolved ? packQuantizedPositionsMM(rightJoints, script.jointsQuantizeMM) : null
    };

    if (script.sendJointRotations) {
      // VERY HEAVY: only enable if you really need it
      payload.jointRots = {
        left: leftResolved ? packRotations(leftJoints) : null,
        right: rightResolved ? packRotations(rightJoints) : null
      };
    }
  }

  safeSendJSON(payload);
}

/* ---------------- Joint resolution (based on your structure) ---------------- */

function resolveLeft() {
  var H = resolveHand(script.leftHandRig);
  if (H) {
    leftWrist = H.wrist;
    leftThumbTip = H.thumbTip;
    leftIndexTip = H.indexTip;
    leftJoints = H.joints;
    leftResolved = true;
    log("[AirMusic] ✅ Left joints resolved");
    safeSendJSON({ type: "resolved", hand: "L", jointCount: leftJoints.length, t: getTime() });
  }
}

function resolveRight() {
  var H = resolveHand(script.rightHandRig);
  if (H) {
    rightWrist = H.wrist;
    rightThumbTip = H.thumbTip;
    rightIndexTip = H.indexTip;
    rightJoints = H.joints;
    rightResolved = true;
    log("[AirMusic] ✅ Right joints resolved");
    safeSendJSON({ type: "resolved", hand: "R", jointCount: rightJoints.length, t: getTime() });
  }
}

function resolveHand(rigRoot) {
  var wrist = findByNameRecursiveSafe(rigRoot, "wrist");
  var thumb3 = findByNameRecursiveSafe(rigRoot, "thumb-3");
  var index3 = findByNameRecursiveSafe(rigRoot, "index-3");
  if (!wrist || !thumb3 || !index3) return null;

  // Compact list: wrist + thumb chain + index chain
  // Keep this list SMALL. (You can add middle/ring/pinky later.)
  var joints = [];
  pushIf(joints, wrist);

  pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-0"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-1"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-2"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-3"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "thumb-3_end"));

  pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-0"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-1"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-2"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-3"));
  pushIf(joints, findByNameRecursiveSafe(rigRoot, "index-3_end"));

  return { wrist: wrist, thumbTip: thumb3, indexTip: index3, joints: joints };
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
  } catch (_e) { return null; }
}

/* ---------------- Packet builders ---------------- */

function buildCompactHand(label, tracking, resolved, wristSO, thumbTipSO, indexTipSO, dt) {
  if (!tracking) {
    return { tracking: false, tracked: false, wrist: null, wristRot: null, speedMps: 0, pinchStrength: 0 };
  }
  if (!resolved) {
    return { tracking: true, tracked: false, wrist: null, wristRot: null, speedMps: 0, pinchStrength: 0 };
  }

  // wrist position
  var wristPos = safeWorldPos(wristSO);
  var wristArr = wristPos ? [wristPos.x, wristPos.y, wristPos.z] : null;

  // wrist rotation (quat)
  var wristRot = safeWorldRot(wristSO);
  var wristRotArr = wristRot ? [wristRot.x, wristRot.y, wristRot.z, wristRot.w] : null;

  // speed
  var speed = 0;
  if (wristPos) {
    if (label === "L") {
      if (prevLeftWristPos) speed = wristPos.distance(prevLeftWristPos) / dt;
      prevLeftWristPos = wristPos;
    } else {
      if (prevRightWristPos) speed = wristPos.distance(prevRightWristPos) / dt;
      prevRightWristPos = wristPos;
    }
  }

  // pinch strength
  var pinch = 0;
  var a = safeWorldPos(thumbTipSO);
  var b = safeWorldPos(indexTipSO);
  if (a && b) {
    var dist = a.distance(b);
    pinch = clamp01(1.0 - (dist / Math.max(script.pinchThresholdM, 1e-4)));
  }

  return {
    tracking: true,
    tracked: true,
    wrist: wristArr,
    wristRot: wristRotArr,
    speedMps: speed,
    pinchStrength: pinch
  };
}

// Quantize positions in millimeters to reduce JSON size and jitter.
// qMM = 2 means values step in 2mm increments.
function packQuantizedPositionsMM(joints, qMM) {
  if (!joints || joints.length === 0) return null;
  var step = Math.max(1, Math.floor(qMM));
  var out = [];
  for (var i = 0; i < joints.length; i++) {
    var p = safeWorldPos(joints[i]);
    if (!p) { out.push(0, 0, 0); continue; }
    // meters -> mm -> quantize
    out.push(
      quantizeMM(p.x, step),
      quantizeMM(p.y, step),
      quantizeMM(p.z, step)
    );
  }
  return out; // ints in mm
}

function quantizeMM(meters, stepMM) {
  var mm = meters * 1000.0;
  return Math.round(mm / stepMM) * stepMM;
}

function packRotations(joints) {
  if (!joints || joints.length === 0) return null;
  var out = [];
  for (var i = 0; i < joints.length; i++) {
    var r = safeWorldRot(joints[i]);
    if (!r) { out.push(0, 0, 0, 1); continue; }
    out.push(r.x, r.y, r.z, r.w);
  }
  return out;
}

/* ---------------- Safe utils ---------------- */

function safeWorldPos(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldPosition();
  } catch (_e) { return null; }
}

function safeWorldRot(so) {
  try {
    if (!so || !so.getTransform) return null;
    return so.getTransform().getWorldRotation(); // quat
  } catch (_e) { return null; }
}

function safeSendJSON(obj) {
  if (!socket || !isOpen) return;
  try {
    socket.send(JSON.stringify(obj));
  } catch (_e) {
    // keep quiet; log spam can crash Lens
  }
}

function clamp01(v) {
  return Math.max(0, Math.min(1, v));
}

onAwake();
