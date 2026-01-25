// TrailMeshBuilderController.js
// Version: 0.0.3
// Event: Initialized
// Description: Creates a magical gradient trail with motion smoothing and soft head/tail fades.

//@ui {"widget":"group_start", "label":"Magical Style"}
//@input vec3 headColor = {1.0, 0.0, 0.46} {"widget":"color", "label":"Hand Color (Pink)"}
//@input vec3 tailColor = {0.58, 0.0, 1.0} {"widget":"color", "label":"Tail Color (Purple)"}
//@input float trailLength = 60 {"min":20, "max":200, "label":"Resolution"}
//@input float shimmerSpeed = 4.0 {"label":"Glow Speed"}
//@input Asset.Material trailMaterial
//@ui {"widget":"group_end"}

//@ui {"widget":"group_start", "label":"Tracking Sources"}
//@input SceneObject cursorBase {"label":"Top Anchor"}
//@input SceneObject cursor {"label":"Bottom Anchor"}
//@ui {"widget":"group_end"}

// Vars
var vertBuffer;
var isInitialized = false;
var renderMeshVisual;
var builder;
var maxLen;
// Variables for smoothing (sub-stepping)
var lastLoc, lastLoc2;

function initialize() {
    if (validateInputs()) {
        setMeshBuilder();
        script.resetTrail();
        isInitialized = true;
    }
}

function setMeshBuilder() {
    if(script.trailMaterial.mainPass) {
        // Ensure base color doesn't tint vertex colors
        script.trailMaterial.mainPass.baseColor = new vec4(1,1,1,1);
    }
    
    renderMeshVisual = script.getSceneObject().createComponent("Component.RenderMeshVisual");
    renderMeshVisual.clearMaterials();
    renderMeshVisual.mainMaterial = script.trailMaterial;
    
    // TriangleStrip requires fewer indices management
    builder = new MeshBuilder([
        { name: "position", components: 3 },
        { name: "color", components: 4 },
    ]);
    builder.topology = MeshTopology.TriangleStrip;
    builder.indexType = MeshIndexType.UInt16;
    
    // Increase length to accommodate sub-steps
    maxLen = script.trailLength * 2;
}

script.resetTrail = function() {
    builder.eraseVertices(0, builder.getVerticesCount());
    builder.eraseIndices(0, builder.getIndicesCount());

    vertBuffer = [];
    var indicesBuffer = [];
    
    // Get initial positions
    var currLoc = script.cursor.getTransform().getWorldPosition();
    var currLoc2 = script.cursorBase.getTransform().getWorldPosition();
    
    // Initialize smoothing variables
    lastLoc = currLoc;
    lastLoc2 = currLoc2;

    var startColor = [script.headColor.r, script.headColor.g, script.headColor.b, 0];

    // Pre-fill buffer collapsed at start point
    for (var i = 0; i < maxLen; i++) {
        indicesBuffer.push(i * 2);
        indicesBuffer.push(i * 2 + 1);
        vertBuffer.push([[currLoc.x, currLoc.y, currLoc.z], startColor]);
        vertBuffer.push([[currLoc2.x, currLoc2.y, currLoc2.z], startColor]);
    }

    for(var j=0; j<vertBuffer.length; j++) builder.appendVertices(vertBuffer[j]);
    builder.appendIndices(indicesBuffer);

    if (builder.isValid()) {
        renderMeshVisual.mesh = builder.getMesh();
        builder.updateMesh();
    }
};

function onUpdate() {
    if (!isInitialized) return;

    // --- 1. SMOOTHING STEP (Interpolation) ---
    // Get current positions
    var currLoc = script.cursor.getTransform().getWorldPosition();
    var currLoc2 = script.cursorBase.getTransform().getWorldPosition();

    // Calculate halfway points between last frame and this frame
    var midLoc = lerpVec3(lastLoc, currLoc, 0.5);
    var midLoc2 = lerpVec3(lastLoc2, currLoc2, 0.5);
    
    // Temp color placeholder
    var tc = [1,1,1,0]; 

    // Remove 2 oldest segments (4 vertices total)
    vertBuffer.shift(); vertBuffer.shift();
    vertBuffer.shift(); vertBuffer.shift();

    // Push the Mid-point segment first
    vertBuffer.push([[midLoc.x, midLoc.y, midLoc.z], tc]);
    vertBuffer.push([[midLoc2.x, midLoc2.y, midLoc2.z], tc]);
    
    // Push the Current-point segment second
    vertBuffer.push([[currLoc.x, currLoc.y, currLoc.z], tc]);
    vertBuffer.push([[currLoc2.x, currLoc2.y, currLoc2.z], tc]);

    // Update last positions for next frame
    lastLoc = currLoc;
    lastLoc2 = currLoc2;


    // --- 2. REBUILD & APPLY MAGIC GRADIENT ---
    builder.eraseVertices(0, builder.getVerticesCount());

    var time = getTime();
    var len = vertBuffer.length;

    for (var i = 0; i < len; i+=2) {
        // ratio: 0.0 = Tail (Oldest), 1.0 = Head (Newest)
        var ratio = i / (len - 2); 
        
        // A. COLOR: Purple (Tail) -> Pink (Head)
        var r = lerp(script.tailColor.r, script.headColor.r, ratio);
        var g = lerp(script.tailColor.g, script.headColor.g, ratio);
        var b = lerp(script.tailColor.b, script.headColor.b, ratio);

        // B. SHIMMER: Faster pulse at head
        var pulse = Math.sin(time * script.shimmerSpeed + (ratio * 8.0)) * 0.15 + 0.85;
        
        // C. SMOOTH FADE IN & OUT CURVE
        // Math.pow(ratio, 0.7) makes the curve lean towards the head.
        // Math.sin( ... * PI) creates a hump shape: starts at 0, peaks, ends at 0.
        // This makes it fade in at the hand, peak just behind the hand, then fade out slowly.
        var alphaCurve = Math.sin(Math.pow(ratio, 0.7) * Math.PI);
        var finalAlpha = alphaCurve * pulse;

        // Apply to bottom and top vertices of the ribbon segment
        vertBuffer[i][1]   = [r, g, b, finalAlpha];
        vertBuffer[i+1][1] = [r, g, b, finalAlpha];

        builder.appendVertices(vertBuffer[i]);
        builder.appendVertices(vertBuffer[i+1]);
    }

    if (builder.isValid()) builder.updateMesh();
}

// --- HELPERS ---
function lerp(start, end, t) {
    return start * (1 - t) + end * t;
}

function lerpVec3(v1, v2, t) {
    return new vec3(
        lerp(v1.x, v2.x, t),
        lerp(v1.y, v2.y, t),
        lerp(v1.z, v2.z, t)
    );
}

function validateInputs() {
    if (!script.trailMaterial || !script.cursor || !script.cursorBase) {
        print("Error: Missing inputs in TrailMeshBuilderController"); return false;
    }
    return true;
}

initialize();
var event = script.createEvent("UpdateEvent");
event.bind(onUpdate);