// SmoothFollow.js
// Put this on the FOLLOWER object.
// Assign "target" to the object you want to follow.

//@input SceneObject target

//@input bool followPosition = true
//@input bool followRotation = false

// How quickly it catches up (higher = snappier). Typical: 6–20
//@input float positionSharpness = 10.0
//@input float rotationSharpness = 12.0

// Local offset from target (in target space)
//@input vec3 localOffset = { "x": 0.0, "y": 0.0, "z": 0.0 }

// Optional max movement speed (units/sec). Set <=0 for unlimited
//@input float maxSpeed = 0.0

// If true, uses target's world space basis for offset; otherwise follower's parent space
//@input bool offsetInWorld = true

// --------- Helpers ----------
function expSmoothingFactor(sharpness, dt) {
    // Returns 0..1 lerp factor that is framerate-independent
    // alpha = 1 - exp(-sharpness * dt)
    return 1.0 - Math.exp(-Math.max(0.0, sharpness) * Math.max(0.0, dt));
}

function clampLength(v, maxLen) {
    var len = v.length;
    if (len > maxLen && maxLen > 0.0) {
        return v.uniformScale(maxLen / len);
    }
    return v;
}

function slerpQuat(a, b, t) {
    // Lens Studio quats have slerp on Quat in recent versions; but keep a fallback:
    if (a && a.slerp) { return a.slerp(b, t); }
    // fallback lerp + normalize
    var q = new quat(
        a.w + (b.w - a.w) * t,
        a.x + (b.x - a.x) * t,
        a.y + (b.y - a.y) * t,
        a.z + (b.z - a.z) * t
    );
    return q.normalize();
}

// --------- Setup ----------
var followerTr = script.getSceneObject().getTransform();
var targetTr = null;

if (script.target) {
    targetTr = script.target.getTransform();
} else {
    print("SmoothFollow: Please assign a target SceneObject.");
}

var updateEvent = script.createEvent("UpdateEvent");
updateEvent.bind(function () {
    if (!targetTr) { return; }

    var dt = getDeltaTime();

    // ---------- Position ----------
    if (script.followPosition) {
        var desiredPos;

        if (script.offsetInWorld) {
            // Offset defined in target space -> convert to world direction using target's rotation
            var targetRot = targetTr.getWorldRotation();
            var worldOffset = targetRot.multiplyVec3(script.localOffset);
            desiredPos = targetTr.getWorldPosition().add(worldOffset);

            var currentPos = followerTr.getWorldPosition();
            var alphaP = expSmoothingFactor(script.positionSharpness, dt);

            var nextPos = currentPos.add(desiredPos.sub(currentPos).uniformScale(alphaP));

            // Optional max speed
            if (script.maxSpeed > 0.0) {
                var step = nextPos.sub(currentPos);
                step = clampLength(step, script.maxSpeed * dt);
                nextPos = currentPos.add(step);
            }

            followerTr.setWorldPosition(nextPos);
        } else {
            // Parent space following
            var parent = script.getSceneObject().getParent();
            var currentPosL = followerTr.getLocalPosition();

            // Desired local pos = target local + offset (assumes same parent)
            var targetLocalPos = targetTr.getLocalPosition();
            desiredPos = targetLocalPos.add(script.localOffset);

            var alphaPL = expSmoothingFactor(script.positionSharpness, dt);
            var nextPosL = currentPosL.add(desiredPos.sub(currentPosL).uniformScale(alphaPL));

            if (script.maxSpeed > 0.0) {
                var stepL = nextPosL.sub(currentPosL);
                stepL = clampLength(stepL, script.maxSpeed * dt);
                nextPosL = currentPosL.add(stepL);
            }

            followerTr.setLocalPosition(nextPosL);
        }
    }

    // ---------- Rotation ----------
    if (script.followRotation) {
        var alphaR = expSmoothingFactor(script.rotationSharpness, dt);

        var currentRot = followerTr.getWorldRotation();
        var desiredRot = targetTr.getWorldRotation();

        var nextRot = slerpQuat(currentRot, desiredRot, alphaR);
        followerTr.setWorldRotation(nextRot);
    }
});
