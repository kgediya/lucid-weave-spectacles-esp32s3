/* global supabase, THREE, window */

// --------------------
// Config
// --------------------
const CFG = window.LW_CONFIG;
if (!CFG) {
  alert("Missing config.js. Copy config.example.js to config.js and fill it.");
  throw new Error("Missing LW_CONFIG");
}

const SUPABASE_URL = CFG.SUPABASE_URL;
const SUPABASE_KEY = CFG.SUPABASE_ANON_KEY;

const SARGAM = CFG.SARGAM;
const FREQS = CFG.FREQS;
const CALIB = CFG.CALIB;
const TRAIL_LEN = CFG.TRAIL_LEN;

const CHANNEL_NAME = CFG.CHANNEL_NAME || "air-music";
const BROADCAST_EVENT = CFG.BROADCAST_EVENT || "controls";

// --------------------
// State
// --------------------
const state = {
  right: { x: 0, y: 0, z: 0, active: false, targetX: 0, targetY: 0, targetZ: 0 },
  left:  { x: 0, y: 0, z: 0, active: false, targetX: 0, targetY: 0, targetZ: 0 }
};

// --------------------
// Utils
// --------------------
function normalize(val, min, max) {
  return Math.max(0, Math.min(1, (val - min) / (max - min)));
}

// --------------------
// Sparkle texture
// --------------------
function getSparkleTex() {
  const canvas = document.createElement("canvas");
  canvas.width = 64; canvas.height = 64;
  const ctx = canvas.getContext("2d");

  const grad = ctx.createRadialGradient(32, 32, 0, 32, 32, 32);
  grad.addColorStop(0, "rgba(255,255,255,1)");
  grad.addColorStop(0.4, "rgba(255,255,255,0.2)");
  grad.addColorStop(1, "rgba(0,0,0,0)");
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, 64, 64);

  ctx.fillStyle = "#ffffff";
  ctx.beginPath();
  ctx.arc(32, 32, 8, 0, Math.PI * 2);
  ctx.fill();

  return new THREE.CanvasTexture(canvas);
}

// --------------------
// Scene
// --------------------
const scene = new THREE.Scene();
scene.fog = new THREE.FogExp2(0x000000, 0.012);

const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 1000);
camera.position.z = 120;

const renderer = new THREE.WebGLRenderer({ antialias: false, powerPreference: "high-performance" });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.setClearColor(0x000000);

document.getElementById("canvas-container").appendChild(renderer.domElement);

const composer = new THREE.EffectComposer(renderer);
composer.addPass(new THREE.RenderPass(scene, camera));

const bloom = new THREE.UnrealBloomPass(
  new THREE.Vector2(window.innerWidth, window.innerHeight),
  2.5, 0.8, 0.0
);
composer.addPass(bloom);

// Stars
const starsGeom = new THREE.BufferGeometry();
const starsPos = new Float32Array(2000 * 3);
for (let i = 0; i < 2000 * 3; i++) starsPos[i] = (Math.random() - 0.5) * 900;
starsGeom.setAttribute("position", new THREE.BufferAttribute(starsPos, 3));
const starsMat = new THREE.PointsMaterial({ color: 0x9D00FF, size: 1.2, transparent: true, opacity: 0.5 });
const stars = new THREE.Points(starsGeom, starsMat);
scene.add(stars);

// --------------------
// Trail system
// --------------------
function createTrail(colorHex) {
  const geom = new THREE.BufferGeometry();
  const pos = new Float32Array(TRAIL_LEN * 3);
  const sizes = new Float32Array(TRAIL_LEN);

  geom.setAttribute("position", new THREE.BufferAttribute(pos, 3));
  geom.setAttribute("size", new THREE.BufferAttribute(sizes, 1));

  const mat = new THREE.PointsMaterial({
    size: 30,
    map: getSparkleTex(),
    transparent: true,
    opacity: 0.8,
    blending: THREE.AdditiveBlending,
    color: new THREE.Color(colorHex),
    depthWrite: false,
    sizeAttenuation: true
  });

  const points = new THREE.Points(geom, mat);
  const buffer = new Float32Array(TRAIL_LEN * 3).fill(-2000);
  return { points, buffer, head: 0 };
}

const rTrail = createTrail(0xFF0077);
const lTrail = createTrail(0x9D00FF);
scene.add(rTrail.points);
scene.add(lTrail.points);

function updateTrailLogic(trail, x, y, z, active) {
  const idx = trail.head * 3;
  trail.buffer[idx] = x;
  trail.buffer[idx + 1] = y;
  trail.buffer[idx + 2] = z;
  trail.head = (trail.head + 1) % TRAIL_LEN;

  const posAttr = trail.points.geometry.attributes.position.array;
  const sizeAttr = trail.points.geometry.attributes.size.array;

  for (let i = 0; i < TRAIL_LEN; i++) {
    const readIdx = (trail.head - 1 - i + TRAIL_LEN) % TRAIL_LEN;
    const bufIdx = readIdx * 3;

    posAttr[i * 3]     = trail.buffer[bufIdx];
    posAttr[i * 3 + 1] = trail.buffer[bufIdx + 1];
    posAttr[i * 3 + 2] = trail.buffer[bufIdx + 2];

    const zDepth = trail.buffer[bufIdx + 2];
    const zScale = 1 + (Math.abs(zDepth) / 50);
    const ageFactor = Math.pow(1.0 - (i / TRAIL_LEN), 1.5);

    let s = ageFactor * 40 * zScale;
    if (!active) s *= 0.94;
    sizeAttr[i] = s;
  }

  trail.points.geometry.attributes.position.needsUpdate = true;
  trail.points.geometry.attributes.size.needsUpdate = true;
}

// --------------------
// Audio
// --------------------
let audioCtx = null;
let rVoice, lVoice;

class LucidSynth {
  constructor(ctx, dest) {
    this.ctx = ctx;
    this.out = ctx.createGain();
    this.out.gain.value = 0;
    this.out.connect(dest);

    this.osc = ctx.createOscillator();
    this.osc.type = "sine";

    this.fm = ctx.createOscillator();
    this.fm.type = "sine";

    this.fmg = ctx.createGain();

    this.fm.connect(this.fmg);
    this.fmg.connect(this.osc.frequency);

    this.osc.connect(this.out);
    this.osc.start();
    this.fm.start();
  }

  update(f, v, res, t) {
    this.osc.frequency.setTargetAtTime(f, t, 0.2);
    this.fm.frequency.setTargetAtTime(f * 2, t, 0.2);
    this.fmg.gain.setTargetAtTime(res * 800, t, 0.2);
    this.out.gain.setTargetAtTime(v * 0.4, t, 0.2);
  }
}

function initAudio() {
  audioCtx = new AudioContext();

  const master = audioCtx.createGain();
  master.connect(audioCtx.destination);

  const d = audioCtx.createDelay();
  d.delayTime.value = 0.5;

  const f = audioCtx.createGain();
  f.gain.value = 0.4;

  d.connect(f);
  f.connect(d);
  master.connect(d);
  d.connect(audioCtx.destination);

  rVoice = new LucidSynth(audioCtx, master);
  lVoice = new LucidSynth(audioCtx, master);
}

// --------------------
// UI scale overlay
// --------------------
const scaleOverlay = document.getElementById("scale-overlay-x");
SARGAM.forEach((n, i) => {
  const d = document.createElement("div");
  d.className = "note-marker-x";
  d.id = `note-${i}`;
  d.setAttribute("data-note", n);
  scaleOverlay.appendChild(d);
});

// --------------------
// Realtime
// --------------------
let sbClient = null;

function applyHandPayload(handState, payloadHand) {
  const h = payloadHand || {};
  const wrist = h.wrist || [0, 0, 0];

  const tracked = !!h.tracked || !!h.tracking;
  handState.active = tracked;

  if (tracked) {
    handState.targetX = wrist[0] || 0;
    handState.targetY = wrist[1] || 0;
    handState.targetZ = wrist[2] || 0;
  }
}

document.getElementById("btn-connect").onclick = async () => {
  initAudio();

  sbClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

  sbClient
    .channel(CHANNEL_NAME)
    .on("broadcast", { event: BROADCAST_EVENT }, ({ payload }) => {
      applyHandPayload(state.right, payload.right);
      applyHandPayload(state.left, payload.left);
    })
    .subscribe();

  document.getElementById("btn-connect").style.display = "none";
};

// --------------------
// Render loop
// --------------------
const camTarget = new THREE.Vector3(0, 0, 120);

function animate() {
  requestAnimationFrame(animate);

  // Hand interpolation
  if (state.right.active) {
    state.right.x += (state.right.targetX - state.right.x) * 0.15;
    state.right.y += (state.right.targetY - state.right.y) * 0.15;
    state.right.z += (state.right.targetZ - state.right.z) * 0.15;
  } else {
    state.right.y += 0.1;
    state.right.x += Math.sin(Date.now() * 0.001) * 0.2;
  }

  if (state.left.active) {
    state.left.x += (state.left.targetX - state.left.x) * 0.15;
    state.left.y += (state.left.targetY - state.left.y) * 0.15;
    state.left.z += (state.left.targetZ - state.left.z) * 0.15;
  } else {
    state.left.y += 0.1;
  }

  updateTrailLogic(rTrail, state.right.x, state.right.y, state.right.z, state.right.active);
  updateTrailLogic(lTrail, state.left.x, state.left.y, state.left.z, state.left.active);

  // Audio update
  if (audioCtx && state.right.active) {
    const nx = normalize(state.right.x, CALIB.x.min, CALIB.x.max);
    const fIdx = Math.floor(nx * (SARGAM.length - 1));
    const ny = normalize(state.right.y, CALIB.y.min, CALIB.y.max);

    rVoice.update(FREQS[fIdx], 0.8, ny, audioCtx.currentTime);

    document.querySelectorAll(".note-marker-x").forEach(m => m.classList.remove("active"));
    const activeEl = document.getElementById(`note-${fIdx}`);
    if (activeEl) activeEl.classList.add("active");
  } else if (audioCtx) {
    rVoice.update(220, 0, 0, audioCtx.currentTime);
  }

  if (audioCtx && state.left.active) {
    lVoice.update(FREQS[0] / 2, 0.5, 0.5, audioCtx.currentTime);
  } else if (audioCtx) {
    lVoice.update(110, 0, 0, audioCtx.currentTime);
  }

  // Cinematic camera
  if (state.right.active) {
    camTarget.set(
      state.right.x * 2.0,
      state.right.y * 2.0,
      120 + (state.right.z * 1.5)
    );
  } else {
    camTarget.set(0, 0, 120);
  }

  camera.position.lerp(camTarget, 0.01);

  const bankAngle = -camera.position.x * 0.002;
  camera.rotation.z += (bankAngle - camera.rotation.z) * 0.02;

  camera.lookAt(camera.position.x * 0.1, camera.position.y * 0.1, 0);

  stars.rotation.z += 0.0002;

  composer.render();
}

animate();

// Controls
document.addEventListener("keydown", (e) => {
  if (e.key.toLowerCase() === "f") {
    if (!document.fullscreenElement) document.documentElement.requestFullscreen();
    else if (document.exitFullscreen) document.exitFullscreen();
  }
});

window.onresize = () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
};
