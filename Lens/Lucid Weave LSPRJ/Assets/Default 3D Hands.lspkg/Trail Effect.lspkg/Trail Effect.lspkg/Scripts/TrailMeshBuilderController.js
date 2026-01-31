// TrailMeshBuilderController.js
// Version: 0.0.4
// Event: Initialized
// Description: Magical gradient trail. Fixed "eraseVertices" crash on init.

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
    
    maxLen = script.trailLength * 2;
}

script.resetTrail = function() {
    // FIX: Check counts before erasing to prevent crash
    var vCount = builder.getVerticesCount();
    var iCount = builder.getIndicesCount();

    if (vCount > 0) {
        builder.eraseVertices(0, vCount);
    }
    if (iCount > 0) {
        builder.eraseIndices(0, iCount);
    }

    vertBuffer = [];
    var indicesBuffer = [];
    
    var currLoc = script.cursor.getTransform().getWorldPosition();
    var currLoc2 = script.cursorBase.getTransform().getWorldPosition();
    
    lastLoc = currLoc;
    lastLoc2 = currLoc2;

    var startColor = [script.headColor.r, script.headColor.g, script.headColor.b, 0];

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

    // --- 1. SMOOTHING STEP ---
    var currLoc = script.cursor.getTransform().getWorldPosition();
    var currLoc2 = script.cursorBase.getTransform().getWorldPosition();

    var midLoc = lerpVec3(lastLoc, currLoc, 0.5);
    var midLoc2 = lerpVec3(lastLoc2, currLoc2, 0.5);
    
    var tc = [1,1,1,0]; 

    vertBuffer.shift(); vertBuffer.shift();
    vertBuffer.shift(); vertBuffer.shift();

    vertBuffer.push([[midLoc.x, midLoc.y, midLoc.z], tc]);
    vertBuffer.push([[midLoc2.x, midLoc2.y, midLoc2.z], tc]);
    
    vertBuffer.push([[currLoc.x, currLoc.y, currLoc.z], tc]);
    vertBuffer.push([[currLoc2.x, currLoc2.y, currLoc2.z], tc]);

    lastLoc = currLoc;
    lastLoc2 = currLoc2;

    // --- 2. REBUILD ---
    var vCount = builder.getVerticesCount();
    if (vCount > 0) builder.eraseVertices(0, vCount);

    var time = getTime();
    var len = vertBuffer.length;

    for (var i = 0; i < len; i+=2) {
        var ratio = i / (len - 2); 
        
        var r = lerp(script.tailColor.r, script.headColor.r, ratio);
        var g = lerp(script.tailColor.g, script.headColor.g, ratio);
        var b = lerp(script.tailColor.b, script.headColor.b, ratio);

        var pulse = Math.sin(time * script.shimmerSpeed + (ratio * 8.0)) * 0.15 + 0.85;
        var alphaCurve = Math.sin(Math.pow(ratio, 0.7) * Math.PI);
        var finalAlpha = alphaCurve * pulse;

        vertBuffer[i][1]   = [r, g, b, finalAlpha];
        vertBuffer[i+1][1] = [r, g, b, finalAlpha];

        builder.appendVertices(vertBuffer[i]);
        builder.appendVertices(vertBuffer[i+1]);
    }

    if (builder.isValid()) builder.updateMesh();
}

function lerp(start, end, t) { return start * (1 - t) + end * t; }
function lerpVec3(v1, v2, t) {
    return new vec3(lerp(v1.x, v2.x, t), lerp(v1.y, v2.y, t), lerp(v1.z, v2.z, t));
}
function validateInputs() {
    if (!script.trailMaterial || !script.cursor || !script.cursorBase) {
        print("Error: Inputs missing"); return false;
    }
    return true;
}

initialize();
var event = script.createEvent("UpdateEvent");
event.bind(onUpdate);