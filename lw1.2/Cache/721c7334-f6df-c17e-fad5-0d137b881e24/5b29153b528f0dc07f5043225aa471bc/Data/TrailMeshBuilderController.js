// TrailMeshBuilderController.js
// Version: 0.0.2
// Event: Initialized
// Description: Creates a magical, shimmering gradient trail for Lucid Weave.

//@ui {"widget":"group_start", "label":"Magical Style"}
//@input vec3 headColor = {1.0, 0.0, 0.46} {"widget":"color", "label":"Hand Color (Pink)"}
//@input vec3 tailColor = {0.58, 0.0, 1.0} {"widget":"color", "label":"Tail Color (Purple)"}
//@input float trailLength = 40 {"min":10, "max":150}
//@input float shimmerSpeed = 3.0 {"label":"Glow Speed"}
//@input Asset.Material trailMaterial
//@ui {"widget":"group_end"}

//@ui {"widget":"group_start", "label":"Tracking Sources"}
//@input SceneObject cursorBase {"label":"Top Anchor"}
//@input SceneObject cursor {"label":"Bottom Anchor"}
//@ui {"widget":"group_end"}

// Vars
var frameCount = 0;
var indicesBuffer;
var vertBuffer;
var isInitialized = false;
var renderMeshVisual;
var builder;
var maxLen;

function initialize() {
    if (validateInputs()) {
        setMeshBuilder();
        script.resetTrail();
        isInitialized = true;
    }
}

function setMeshBuilder() {
    // Set base material color to white so vertex colors show through purely
    if(script.trailMaterial.mainPass) {
        script.trailMaterial.mainPass.baseColor = new vec4(1,1,1,1);
    }
    
    renderMeshVisual = script.getSceneObject().createComponent("Component.RenderMeshVisual");
    renderMeshVisual.clearMaterials();
    renderMeshVisual.mainMaterial = script.trailMaterial;
    
    builder = new MeshBuilder([
        { name: "position", components: 3 },
        { name: "color", components: 4 },
    ]);
    builder.topology = MeshTopology.TriangleStrip;
    builder.indexType = MeshIndexType.UInt16;
    
    maxLen = script.trailLength;
}

script.resetTrail = function() {
    var verticesCount = builder.getVerticesCount();
    var indicesCount = builder.getIndicesCount();
    if (verticesCount > 0) {
        builder.eraseVertices(0, verticesCount);
        builder.eraseIndices(0, indicesCount);
    }

    // Initialize buffers
    indicesBuffer = [];
    vertBuffer = [];
    
    // Get start positions
    var loc = script.cursor.getTransform().getWorldPosition();
    var loc2 = script.cursorBase.getTransform().getWorldPosition();
    var startColor = [script.headColor.r, script.headColor.g, script.headColor.b, 1];

    // Pre-fill buffer to avoid popping
    // We add 2 vertices per segment (Triangle Strip)
    for (var i = 0; i < maxLen; i++) {
        indicesBuffer.push(i * 2);
        indicesBuffer.push(i * 2 + 1);

        // Store Position [x,y,z] and Color [r,g,b,a]
        // Initially collapse all points to the hand so it "grows" out
        vertBuffer.push([[loc.x, loc.y, loc.z], startColor]);
        vertBuffer.push([[loc2.x, loc2.y, loc2.z], startColor]);
    }

    // Initial Build
    for(var j=0; j<vertBuffer.length; j++) {
        builder.appendVertices(vertBuffer[j]);
    }
    builder.appendIndices(indicesBuffer);

    if (builder.isValid()) {
        renderMeshVisual.mesh = builder.getMesh();
        builder.updateMesh();
    }
};

function onUpdate() {
    if (!isInitialized) return;

    frameCount++;

    // 1. UPDATE GEOMETRY
    // Remove oldest segment (2 vertices)
    vertBuffer.shift();
    vertBuffer.shift();

    // Add new segment at current hand position
    var loc = script.cursor.getTransform().getWorldPosition();
    var loc2 = script.cursorBase.getTransform().getWorldPosition();
    
    // Placeholder color (will be overwritten by gradient logic below)
    var tempColor = [1, 1, 1, 1]; 

    vertBuffer.push([[loc.x, loc.y, loc.z], tempColor]);
    vertBuffer.push([[loc2.x, loc2.y, loc2.z], tempColor]);

    // 2. REBUILD & APPLY MAGIC GRADIENT
    var verticesCount = builder.getVerticesCount();
    builder.eraseVertices(0, verticesCount);

    var totalSegments = vertBuffer.length / 2;
    var time = getTime();

    for (var i = 0; i < vertBuffer.length; i+=2) {
        // Calculate normalized position along trail (0.0 = Tail, 1.0 = Head)
        var ratio = i / vertBuffer.length;
        
        // A. COLOR INTERPOLATION (Purple -> Pink)
        var r = lerp(script.tailColor.r, script.headColor.r, ratio);
        var g = lerp(script.tailColor.g, script.headColor.g, ratio);
        var b = lerp(script.tailColor.b, script.headColor.b, ratio);

        // B. ETHEREAL SHIMMER
        // Uses sine wave based on Time + Index to create a "pulsing" wave effect
        var pulse = Math.sin(time * script.shimmerSpeed + (ratio * 5.0)) * 0.2 + 0.8;
        
        // C. ALPHA FADE
        // Math.pow makes the fade curve non-linear (stays visible longer)
        var alpha = Math.pow(ratio, 1.5) * pulse;

        // Apply to Bottom Vertex
        vertBuffer[i][1][0] = r;
        vertBuffer[i][1][1] = g;
        vertBuffer[i][1][2] = b;
        vertBuffer[i][1][3] = alpha;
        
        // Apply to Top Vertex
        vertBuffer[i+1][1][0] = r;
        vertBuffer[i+1][1][1] = g;
        vertBuffer[i+1][1][2] = b;
        vertBuffer[i+1][1][3] = alpha;

        // Push to Builder
        builder.appendVertices(vertBuffer[i]);
        builder.appendVertices(vertBuffer[i+1]);
    }

    if (builder.isValid()) {
        builder.updateMesh();
    }
}

// Helper: Linear Interpolation
function lerp(start, end, t) {
    return start * (1 - t) + end * t;
}

function validateInputs() {
    if (!script.trailMaterial) {
        print("Error: Material missing"); return false;
    }
    if (!script.cursor || !script.cursorBase) {
        print("Error: Cursor objects missing"); return false;
    }
    return true;
}

initialize();
var event = script.createEvent("UpdateEvent");
event.bind(onUpdate);