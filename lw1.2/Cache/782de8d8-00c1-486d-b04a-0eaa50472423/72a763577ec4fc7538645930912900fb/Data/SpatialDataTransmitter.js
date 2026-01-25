// AirMusic_HandStream.ts
// Spectacles: streams 3D hand joints + derived gesture features to your WebSocket server.
//
// Requires:
// - Asset.InternetModule input
// - wss:// URL (ws:// requires Experimental APIs; not publishable)
//
// Docs: InternetModule.createWebSocket + WebSocket events :contentReference[oaicite:1]{index=1}

@component
export class AirMusicHandStream extends BaseScriptComponent {
  @input internetModule!: InternetModule;

  @input("string")
  wsUrl: string = "wss://YOUR_SERVER_URL";

  // Drag joint SceneObjects here (Object Tracking 3D hand joints).
  // Keep consistent ordering between left/right if your server expects indices.
  @input
  leftJoints: SceneObject[] = [];

  @input
  rightJoints: SceneObject[] = [];

  // Which indices in the arrays represent thumb tip and index tip?
  // (Set these to match your joint list ordering)
  @input("int")
  leftThumbTipIndex: number = 4;

  @input("int")
  leftIndexTipIndex: number = 8;

  @input("int")
  rightThumbTipIndex: number = 4;

  @input("int")
  rightIndexTipIndex: number = 8;

  // Network send rate (Hz). 20–30 is usually enough.
  @input("float")
  sendHz: number = 25;

  // Pinch distance threshold in meters (tune this!)
  @input("float")
  pinchThresholdM: number = 0.03;

  // Optional: include rotations (heavier payload)
  @input
  includeRotations: boolean = false;

  private socket: WebSocket | null = null;
  private isOpen: boolean = false;

  private nextSendTime: number = 0;
  private reconnectAttempt: number = 0;
  private reconnectAtTime: number = 0;

  // For velocity estimation
  private prevLeftWristPos: vec3 | null = null;
  private prevRightWristPos: vec3 | null = null;
  private prevTimeS: number = 0;

  onAwake() {
    if (!this.internetModule) {
      print("[AirMusic] Missing InternetModule input.");
      return;
    }

    this.connect();

    const updateEvent = this.createEvent("UpdateEvent");
    updateEvent.bind(() => this.onUpdate());
  }

  private connect() {
    try {
      print(`[AirMusic] Connecting WS: ${this.wsUrl}`);
      this.socket = this.internetModule.createWebSocket(this.wsUrl);
      this.socket.binaryType = "blob"; // required by current limitations :contentReference[oaicite:2]{index=2}

      this.socket.onopen = (_e: WebSocketEvent) => {
        this.isOpen = true;
        this.reconnectAttempt = 0;
        print("[AirMusic] WebSocket Connected ✅");

        // optional hello
        this.safeSendJSON({ type: "hello", app: "AirMusic", t: getTime() });
      };

      this.socket.onmessage = async (e: WebSocketMessageEvent) => {
        // Optional: handle server commands (e.g., scale/preset updates)
        if (typeof e.data === "string") {
          // print("[AirMusic] RX: " + e.data);
        }
      };

      this.socket.onclose = (e: WebSocketCloseEvent) => {
        this.isOpen = false;
        print(`[AirMusic] WS Closed. code=${e.code} clean=${e.wasClean}`);
        this.scheduleReconnect();
      };

      this.socket.onerror = (_e: WebSocketEvent) => {
        this.isOpen = false;
        print("[AirMusic] WS Error");
        this.scheduleReconnect();
      };
    } catch (err) {
      print("[AirMusic] WS connect failed: " + err);
      this.isOpen = false;
      this.scheduleReconnect();
    }
  }

  private scheduleReconnect() {
    // simple backoff: 0.5s, 1s, 2s, 4s, max 8s
    const delay = Math.min(0.5 * Math.pow(2, this.reconnectAttempt), 8.0);
    this.reconnectAttempt++;
    this.reconnectAtTime = getTime() + delay;
    print(`[AirMusic] Reconnect in ${delay.toFixed(1)}s...`);
  }

  private onUpdate() {
    const now = getTime();

    // reconnect if needed
    if (!this.isOpen && this.reconnectAtTime > 0 && now >= this.reconnectAtTime) {
      this.reconnectAtTime = 0;
      this.connect();
    }

    // throttle send
    const interval = 1.0 / Math.max(this.sendHz, 1);
    if (now < this.nextSendTime) return;
    this.nextSendTime = now + interval;

    if (!this.socket || !this.isOpen) return;

    const dt = (this.prevTimeS > 0) ? Math.max(now - this.prevTimeS, 1e-4) : 1 / 60;
    this.prevTimeS = now;

    const left = this.buildHandPacket("L", this.leftJoints, this.leftThumbTipIndex, this.leftIndexTipIndex, dt);
    const right = this.buildHandPacket("R", this.rightJoints, this.rightThumbTipIndex, this.rightIndexTipIndex, dt);

    const payload = {
      type: "handFrame",
      t: now,
      dt,
      left,
      right,
    };

    this.safeSendJSON(payload);
  }

  private buildHandPacket(
    label: "L" | "R",
    joints: SceneObject[],
    thumbTipIdx: number,
    indexTipIdx: number,
    dt: number
  ) {
    const valid = joints && joints.length > 0;

    // Joints positions (world)
    const positions: number[] = [];
    const rotations: number[] = [];

    if (valid) {
      for (let i = 0; i < joints.length; i++) {
        const so = joints[i];
        if (!so) {
          positions.push(0, 0, 0);
          if (this.includeRotations) rotations.push(0, 0, 0, 1);
          continue;
        }

        const tr = so.getTransform();
        const p = tr.getWorldPosition();
        positions.push(p.x, p.y, p.z);

        if (this.includeRotations) {
          const r = tr.getWorldRotation(); // quat
          rotations.push(r.x, r.y, r.z, r.w);
        }
      }
    }

    // Pinch strength = 1 when thumb/index are close, 0 when far
    let pinchStrength = 0;
    if (valid && joints[thumbTipIdx] && joints[indexTipIdx]) {
      const a = joints[thumbTipIdx].getTransform().getWorldPosition();
      const b = joints[indexTipIdx].getTransform().getWorldPosition();
      const dist = a.distance(b);
      pinchStrength = this.clamp01(1.0 - (dist / Math.max(this.pinchThresholdM, 1e-4)));
    }

    // Velocity (use joint 0 as "wrist" by convention; adjust if your list differs)
    let speed = 0;
    if (valid && joints[0]) {
      const wrist = joints[0].getTransform().getWorldPosition();
      if (label === "L") {
        if (this.prevLeftWristPos) speed = wrist.distance(this.prevLeftWristPos) / dt;
        this.prevLeftWristPos = wrist;
      } else {
        if (this.prevRightWristPos) speed = wrist.distance(this.prevRightWristPos) / dt;
        this.prevRightWristPos = wrist;
      }
    }

    return {
      tracked: valid,
      jointCount: joints ? joints.length : 0,
      positions,           // [x,y,z,x,y,z,...]
      rotations: this.includeRotations ? rotations : undefined, // [x,y,z,w,...]
      pinchStrength,       // 0..1
      speedMps: speed      // meters/sec
    };
  }

  private safeSendJSON(obj: any) {
    if (!this.socket || !this.isOpen) return;
    try {
      const s = JSON.stringify(obj);
      this.socket.send(s);
    } catch (e) {
      print("[AirMusic] send failed: " + e);
    }
  }

  private clamp01(v: number) {
    return Math.max(0, Math.min(1, v));
  }
}
