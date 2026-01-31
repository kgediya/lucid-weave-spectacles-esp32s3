window.LW_CONFIG = {
  // Snapcloud Supabase (Supabase-compatible endpoint routed via Snapcloud)
  // Example: https://<ref>.snapcloud.dev
  SUPABASE_URL: "https://YOUR_REF.snapcloud.dev",
  SUPABASE_ANON_KEY: "YOUR_ANON_KEY",

  CHANNEL_NAME: "air-music",
  BROADCAST_EVENT: "controls",

  CALIB: {
    x: { min: -25, max: 25 },
    y: { min: -70, max: 5 },
    z: { min: -40, max: -5 }
  },

  SARGAM: ["Do", "Re", "Mi", "Fa", "Sol", "La", "Ti", "Do"],
  FREQS:  [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25],

  TRAIL_LEN: 80
};
