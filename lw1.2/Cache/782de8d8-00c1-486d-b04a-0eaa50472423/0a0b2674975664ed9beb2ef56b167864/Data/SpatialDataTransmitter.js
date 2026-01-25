// AirMusic_HandStream.js
// Spectacles: streams 3D hand joints + derived gesture features to your WebSocket server.
//
// Requires:
// - Asset.InternetModule input (drag into Inspector)
// - wss:// URL (ws:// requires Experimental APIs; not publishable)
//
// Notes:
// - WebSocket binaryType must be "blob" on Spectacles currently.
// - Keep joint ordering consistent with your server expectation.

//@input Asset.InternetModule internetModule
//@input string wsUrl = "wss://YOUR_SERVER_URL"

// Drag joint SceneObjects here (Object Tracking 3D hand joints).
// Keep consistent ordering between left/right if your server expects indices.
//@input SceneObject[] leftJoints
//@input SceneObject[] rightJoints

// Which indices represent thumb tip and index tip in the arrays?
//@input int leftThumbTipIndex = 4
//@input int leftIndexTipIndex = 8
//@input int rightThumbTipIndex = 4
//@input int rightIndexTipIndex = 8

// Network send rate (Hz). 20–30 is usually enough.
//@input float sendHz = 25

// Pinch distance threshold in meters (tune this!)
//@input float pinchThresholdM = 0.03

// Optional: include rotations (heavier payload)
//@input bool includeRotations = false

// ---------------- Internal state ----------------
var socket = null;
var isOpen = false;

var nextSendTime = 0;
var reconnectAttempt = 0;
var reconnectAtTime = 0;

// For velocity estimation
var prevLeftWristPos = null;   // vec3
var prevRightWristPos = null;  // vec3
var prevTimeS = 0;

function onAwake() {
  if (!script.internetModule) {
    print("[AirMusic] Missing InternetModule input.");
    return;
  }

  connect();

  var updateEvent = script.createEvent("UpdateEvent");
  updateEvent.bind(onUpdate);
}

function connect() {
  try {
    print("[AirMusic] Connecting WS: " + script.wsUrl);

    socket = script.internetModule.createWebSocket(script.wsUrl);
    socket.binaryType = "blob"; // required by current limitations on Spectacles

    socket.onopen = function (_e) {
      isOpen = true;
      reconnectAttempt = 0;
      print("[AirMusic] WebSocket Connected ✅");

      safeSendJSON({ type: "hello", app: "AirMusic", t: getTime() });
    };

    socket.onmessage = function (e) {
      // Optional: handle server commands
      // if (typeof e.data === "string") { print("[AirMusic] RX: " + e.data); }
    };

    socket.onclose = function (e) {
      isOpen = false;
      print("[AirMusic] WS Closed. code=" + e.code + " clean=" + e.wasClean);
      scheduleReconnect();
    };

    socket.onerror = function (_e) {
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
  // simple backoff: 0.5s, 1s, 2s, 4s... max 8s
  var delay = Math.min(0.5 * Math.pow(2, reconnectAttempt), 8.0);
  reconnectAttempt += 1;
  reconnectAtTime = getTime() + delay;
  print("[AirMusic] Reconnect in " + delay.toFixed(1) + "s...");
}

function onUpdate() {
  var now = getTime();

  // reconnect if needed
  if (!isOpen && reconnectAtTime > 0 && now >= reconnectAtTime) {
    reconnectAtTime = 0;
    connect();
  }

  // throttle send
  var interval = 1.0 / Math.max(script.sendHz, 1);
  if (now < nextSendTime) return;
  nextSendTime = now + interval;

  if (!socket || !isOpen) return;

  var dt = (prevTimeS > 0) ? Math.max(now - prevTimeS, 1e-4) : (1 / 60);
  prevTimeS = now;

  var left = buildHandPacket("L", script.leftJoints, script.leftThumbTipIndex, script.leftIndexTipIndex, dt);
  var right = buildHandPacket("R", script.rightJoints, script.rightThumbTipIndex, script.rightIndexTipIndex, dt);

  var payload = {
    type: "handFrame",
    t: now,
    dt: dt,
    left: left,
    right: right
  };

  safeSendJSON(payload);
}

function buildHandPacket(label, joints, thumbTipIdx, indexTipIdx, dt) {
  var valid = joints && joints.length > 0;

  var positions = []; // [x,y,z,...]
  var rotations = []; // [x,y,z,w,...] (if enabled)

  if (valid) {
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
        var r = tr.getWorldRotation(); // quat
        rotations.push(r.x, r.y, r.z, r.w);
      }
    }
  }

  // Pinch strength = 1 when thumb/index are close, 0 when far
  var pinchStrength = 0;
  if (valid && joints[thumbTipIdx] && joints[indexTipIdx]) {
    var a = joints[thumbTipIdx].getTransform().getWorldPosition();
    var b = joints[indexTipIdx].getTransform().getWorldPosition();
    var dist = a.distance(b);
    pinchStrength = clamp01(1.0 - (dist / Math.max(script.pinchThresholdM, 1e-4)));
  }

  // Velocity from wrist (joint 0 by convention)
  var speed = 0;
  if (valid && joints[0]) {
    var wrist = joints[0].getTransform().getWorldPosition();
    if (label === "L") {
      if (prevLeftWristPos) speed = wrist.distance(prevLeftWristPos) / dt;
      prevLeftWristPos = wrist;
    } else {
      if (prevRightWristPos) speed = wrist.distance(prevRightWristPos) / dt;
      prevRightWristPos = wrist;
    }
  }

  return {
    tracked: valid,
    jointCount: joints ? joints.length : 0,
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
