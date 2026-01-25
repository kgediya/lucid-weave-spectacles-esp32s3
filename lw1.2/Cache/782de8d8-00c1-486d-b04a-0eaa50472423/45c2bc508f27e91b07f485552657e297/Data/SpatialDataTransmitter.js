// AirMusic_HandStream_AutoJoints.js
// Auto-resolves wrist + thumb/index joints by NAME from your hierarchy,
// then streams positions + pinchStrength + wrist speed via WebSocket.

//@input Asset.InternetModule internetModule
//@input string wsUrl = "wss://YOUR_SERVER_URL"

// Drag these rig roots from your hierarchy:
// LeftHandModel -> LeftHandRig  (same for Right if available)
//@input SceneObject leftHandRig
//@input SceneObject rightHandRig

//@input float sendHz = 25
//@input float pinchThresholdM = 0.03
//@input bool includeRotations = false

// ---------------- Internal state ----------------
var socket = null;
var isOpen = false;

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

var prevLeftWristPos = null;
var prevRightWristPos = null;
var prevTimeS = 0;

// Resolved joints per hand (in a stable order for server parsing)
var leftJoints = [];
var rightJoints = [];

var leftWrist = null, rightWrist = null;
var leftThumbTip = null, rightThumbTip = null;
var leftIndexTip = null, rightIndexTip = null;

function onAwake() {
  if (!script.internetModule) {
    print("[AirMusic] Missing InternetModule input.");
    return;
  }

  // Build joint lists from hierarchy
  resolveAllJoints();

  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
}

function resolveAllJoints() {
  // Left
  if (script.leftHandRig) {
    var L = resolveHand(script.leftHandRig);
    leftJoints = L.joints;
    leftWrist = L.wrist;
    leftThumbTip = L.thumbTip;
    leftIndexTip = L.indexTip;
    print("[AirMusic] Left joints resolved: " + leftJoints.length);
  } else {
    print("[AirMusic] leftHandRig not set.");
  }

  // Right
  if (script.rightHandRig) {
    var R = resolveHand(script.rightHandRig);
    rightJoints = R.joints;
    rightWrist = R.wrist;
    rightThumbTip = R.thumbTip;
    rightIndexTip = R.indexTip;
    print("[AirMusic] Right joints resolved: " + rightJoints.length);
  } else {
    // It’s OK if you only have left for now.
    // print("[AirMusic] rightHandRig not set.");
  }
}

function resolveHand(rigRoot) {
  // Your hierarchy contains:
  // wrist
  // wrist_to_thumb -> thumb-0 -> thumb-1 -> thumb-2 -> thumb-3 -> thumb-3_end...
  // wrist_to_index -> index-0 -> index-1 -> index-2 -> index-3 -> index-3_end...
  //
  // For pinch we use thumb-3 and index-3 (stable & less jittery).

  var wrist = findByNameRecursive(rigRoot, "wrist");
  var thumb0 = findByNameRecursive(rigRoot, "thumb-0");
  var thumb1 = findByNameRecursive(rigRoot, "thumb-1");
  var thumb2 = findByNameRecursive(rigRoot, "thumb-2");
  var thumb3 = findByNameRecursive(rigRoot, "thumb-3");

  var index0 = findByNameRecursive(rigRoot, "index-0");
  var index1 = findByNameRecursive(rigRoot, "index-1");
  var index2 = findByNameRecursive(rigRoot, "index-2");
  var index3 = findByNameRecursive(rigRoot, "index-3");

  // Optional extra joints (nice for modulation / visuals), but NOT used for pinch:
  var thumb3end = findByNameRecursive(rigRoot, "thumb-3_end");
  var index3end = findByNameRecursive(rigRoot, "index-3_end");

  // Build a consistent order the server can rely on
  var joints = [];
  pushIf(joints, wrist);

  // thumb chain
  pushIf(joints, thumb0);
  pushIf(joints, thumb1);
  pushIf(joints, thumb2);
  pushIf(joints, thumb3);
  pushIf(joints, thumb3end);

  // index chain
  pushIf(joints, index0);
  pushIf(joints, index1);
  pushIf(joints, index2);
  pushIf(joints, index3);
  pushIf(joints, index3end);

  return {
    joints: joints,
    wrist: wrist,
    thumbTip: thumb3,  // ✅ stable pinch tip
    indexTip: index3   // ✅ stable pinch tip
  };
}

function pushIf(arr, so) {
  if (so) arr.push(so);
}

function findByNameRecursive(root, name) {
  if (!root) return null;

  // Lens Studio SceneObject has .name in JS
  if (root.name === name) return root;

  var childrenCount = root.getChildrenCount();
  for (var i = 0; i < childrenCount; i++) {
    var child = root.getChild(i);
    var found = findByNameRecursive(child, name);
    if (found) return found;
  }
  return null;
}

function connect() {
  try {
    print("[AirMusic] Connecting WS: " + script.wsUrl);

    socket = script.internetModule.createWebSocket(script.wsUrl);
    socket.binaryType = "blob";

    socket.onopen = function () {
      isOpen = true;
      reconnectAttempt = 0;
      print("[AirMusic] WebSocket Connected ✅");
      safeSendJSON({ type: "hello", app: "AirMusic", t: getTime() });
    };

    socket.onclose = function (e) {
      isOpen = false;
      print("[AirMusic] WS Closed. code=" + e.code + " clean=" + e.wasClean);
      scheduleReconnect();
    };

    socket.onerror = function () {
      isOpen = false;
      print("[AirMusic] WS Error");
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
  print("[AirMusic] Reconnect in " + delay.toFixed(1) + "s...");
}

function onUpdate() {
  var now = getTime();

  // Re-resolve joints if rigs load late / get replaced
  // (hand templates sometimes initialize after Awake)
  if (script.leftHandRig && leftJoints.length === 0) resolveAllJoints();
  if (script.rightHandRig && rightJoints.length === 0) resolveAllJoints();

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

  var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
  prevTimeS = now;

  var left = buildHandPacket("L", leftJoints, leftWrist, leftThumbTip, leftIndexTip, dt);
  var right = buildHandPacket("R", rightJoints, rightWrist, rightThumbTip, rightIndexTip, dt);

  safeSendJSON({
    type: "handFrame",
    t: now,
    dt: dt,
    left: left,
    right: right
  });
}

function buildHandPacket(label, joints, wristSO, thumbTipSO, indexTipSO, dt) {
  var tracked = joints && joints.length > 0;

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
      var tr = so.getTransform();
      var p = tr.getWorldPosition();
      positions.push(p.x, p.y, p.z);

      if (script.includeRotations) {
        var r = tr.getWorldRotation();
        rotations.push(r.x, r.y, r.z, r.w);
      }
    }
  }

  // Pinch strength using thumb-3 and index-3 (stable)
  var pinchStrength = 0;
  if (thumbTipSO && indexTipSO) {
    var a = thumbTipSO.getTransform().getWorldPosition();
    var b = indexTipSO.getTransform().getWorldPosition();
    var dist = a.distance(b);
    pinchStrength = clamp01(1.0 - (dist / Math.max(script.pinchThresholdM, 1e-4)));
  }

  // Wrist speed for intensity
  var speed = 0;
  if (wristSO) {
    var w = wristSO.getTransform().getWorldPosition();
    if (label === "L") {
      if (prevLeftWristPos) speed = w.distance(prevLeftWristPos) / dt;
      prevLeftWristPos = w;
    } else {
      if (prevRightWristPos) speed = w.distance(prevRightWristPos) / dt;
      prevRightWristPos = w;
    }
  }

  return {
    tracked: tracked,
    jointCount: joints ? joints.length : 0,
    // IMPORTANT: this order is now: wrist, thumb0..3, thumb3_end, index0..3, index3_end
    positions: positions,
    rotations: script.includeRotations ? rotations : undefined,
    pinchStrength: pinchStrength,
    speedMps: speed
  };
}

function safeSendJSON(obj) {
  if (!socket || !isOpen) return;
  try {
    socket.send(JSON.stringify(obj));
  } catch (e) {
    print("[AirMusic] send failed: " + e);
  }
}

function clamp01(v) {
  return Math.max(0, Math.min(1, v));
}

onAwake();
