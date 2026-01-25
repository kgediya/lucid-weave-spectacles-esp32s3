#version 430
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
// SCC_BACKEND_SHADER_FLAGS_BEGIN__
// NGS_FLAG_IS_NORMAL_MAP normalTex
// NGS_FLAG_IS_NORMAL_MAP detailNormalTex
// SCC_BACKEND_SHADER_FLAGS_END__
//SG_REFLECTION_BEGIN(200)
//attribute vec4 boneData 5
//attribute vec3 blendShape0Pos 6
//attribute vec3 blendShape0Normal 12
//attribute vec3 blendShape1Pos 7
//attribute vec3 blendShape1Normal 13
//attribute vec3 blendShape2Pos 8
//attribute vec3 blendShape2Normal 14
//attribute vec3 blendShape3Pos 9
//attribute vec3 blendShape4Pos 10
//attribute vec3 blendShape5Pos 11
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec4 color 18
//attribute vec3 positionNext 15
//attribute vec3 positionPrevious 16
//attribute vec4 strandProperties 17
//output vec4 sc_FragData0 0
//sampler sampler baseTexSmpSC 0:28
//sampler sampler detailNormalTexSmpSC 0:29
//sampler sampler emissiveTexSmpSC 0:30
//sampler sampler intensityTextureSmpSC 0:31
//sampler sampler normalTexSmpSC 0:32
//sampler sampler opacityTexSmpSC 0:33
//sampler sampler reflectionModulationTexSmpSC 0:34
//sampler sampler reflectionTexSmpSC 0:35
//sampler sampler rimColorTexSmpSC 0:36
//sampler sampler sc_OITCommonSampler 0:39
//sampler sampler sc_RayTracingHitCasterIdAndBarycentricSmpSC 0:40
//sampler sampler sc_RayTracingRayDirectionSmpSC 0:41
//sampler sampler sc_ScreenTextureSmpSC 0:43
//texture texture2D baseTex 0:3:0:28
//texture texture2D detailNormalTex 0:4:0:29
//texture texture2D emissiveTex 0:5:0:30
//texture texture2D intensityTexture 0:6:0:31
//texture texture2D normalTex 0:7:0:32
//texture texture2D opacityTex 0:8:0:33
//texture texture2D reflectionModulationTex 0:9:0:34
//texture texture2D reflectionTex 0:10:0:35
//texture texture2D rimColorTex 0:11:0:36
//texture texture2D sc_OITAlpha0 0:14:0:39
//texture texture2D sc_OITAlpha1 0:15:0:39
//texture texture2D sc_OITDepthHigh0 0:16:0:39
//texture texture2D sc_OITDepthHigh1 0:17:0:39
//texture texture2D sc_OITDepthLow0 0:18:0:39
//texture texture2D sc_OITDepthLow1 0:19:0:39
//texture texture2D sc_OITFilteredDepthBoundsTexture 0:20:0:39
//texture texture2D sc_OITFrontDepthTexture 0:21:0:39
//texture utexture2D sc_RayTracingHitCasterIdAndBarycentric 0:22:0:40
//texture texture2D sc_RayTracingRayDirection 0:23:0:41
//texture texture2D sc_ScreenTexture 0:25:0:43
//texture texture2DArray baseTexArrSC 0:46:0:28
//texture texture2DArray detailNormalTexArrSC 0:47:0:29
//texture texture2DArray emissiveTexArrSC 0:48:0:30
//texture texture2DArray intensityTextureArrSC 0:49:0:31
//texture texture2DArray normalTexArrSC 0:50:0:32
//texture texture2DArray opacityTexArrSC 0:51:0:33
//texture texture2DArray reflectionModulationTexArrSC 0:52:0:34
//texture texture2DArray reflectionTexArrSC 0:53:0:35
//texture texture2DArray rimColorTexArrSC 0:54:0:36
//texture texture2DArray sc_ScreenTextureArrSC 0:58:0:43
//ssbo int sc_RayTracingCasterIndexBuffer 0:0:4 {
//uint sc_RayTracingCasterTriangles 0:[1]:4
//}
//ssbo float sc_RayTracingCasterNonAnimatedVertexBuffer 0:2:4 {
//float sc_RayTracingCasterNonAnimatedVertices 0:[1]:4
//}
//ssbo float sc_RayTracingCasterVertexBuffer 0:1:4 {
//float sc_RayTracingCasterVertices 0:[1]:4
//}
//spec_const bool BLEND_MODE_AVERAGE 0 0
//spec_const bool BLEND_MODE_BRIGHT 1 0
//spec_const bool BLEND_MODE_COLOR 2 0
//spec_const bool BLEND_MODE_COLOR_BURN 3 0
//spec_const bool BLEND_MODE_COLOR_DODGE 4 0
//spec_const bool BLEND_MODE_DARKEN 5 0
//spec_const bool BLEND_MODE_DIFFERENCE 6 0
//spec_const bool BLEND_MODE_DIVIDE 7 0
//spec_const bool BLEND_MODE_DIVISION 8 0
//spec_const bool BLEND_MODE_EXCLUSION 9 0
//spec_const bool BLEND_MODE_FORGRAY 10 0
//spec_const bool BLEND_MODE_HARD_GLOW 11 0
//spec_const bool BLEND_MODE_HARD_LIGHT 12 0
//spec_const bool BLEND_MODE_HARD_MIX 13 0
//spec_const bool BLEND_MODE_HARD_PHOENIX 14 0
//spec_const bool BLEND_MODE_HARD_REFLECT 15 0
//spec_const bool BLEND_MODE_HUE 16 0
//spec_const bool BLEND_MODE_INTENSE 17 0
//spec_const bool BLEND_MODE_LIGHTEN 18 0
//spec_const bool BLEND_MODE_LINEAR_LIGHT 19 0
//spec_const bool BLEND_MODE_LUMINOSITY 20 0
//spec_const bool BLEND_MODE_NEGATION 21 0
//spec_const bool BLEND_MODE_NOTBRIGHT 22 0
//spec_const bool BLEND_MODE_OVERLAY 23 0
//spec_const bool BLEND_MODE_PIN_LIGHT 24 0
//spec_const bool BLEND_MODE_REALISTIC 25 0
//spec_const bool BLEND_MODE_SATURATION 26 0
//spec_const bool BLEND_MODE_SOFT_LIGHT 27 0
//spec_const bool BLEND_MODE_SUBTRACT 28 0
//spec_const bool BLEND_MODE_VIVID_LIGHT 29 0
//spec_const bool ENABLE_BASE_TEX 30 0
//spec_const bool ENABLE_DETAIL_NORMAL 31 0
//spec_const bool ENABLE_EMISSIVE 32 0
//spec_const bool ENABLE_NORMALMAP 33 0
//spec_const bool ENABLE_OPACITY_TEX 34 0
//spec_const bool ENABLE_RECOLOR 35 0
//spec_const bool ENABLE_REFLECTION_MODULATION_TEX 36 0
//spec_const bool ENABLE_RIM_COLOR_TEX 37 0
//spec_const bool ENABLE_RIM_HIGHLIGHT 38 0
//spec_const bool ENABLE_RIM_INVERT 39 0
//spec_const bool ENABLE_STIPPLE_PATTERN_TEST 40 0
//spec_const bool ENABLE_UV2 41 0
//spec_const bool ENABLE_UV2_ANIMATION 42 0
//spec_const bool ENABLE_UV3 43 0
//spec_const bool ENABLE_UV3_ANIMATION 44 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_baseTex 45 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_detailNormalTex 46 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_emissiveTex 47 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_intensityTexture 48 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_normalTex 49 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_opacityTex 50 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_reflectionModulationTex 51 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_reflectionTex 52 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_rimColorTex 53 0
//spec_const bool SC_USE_UV_MIN_MAX_baseTex 54 0
//spec_const bool SC_USE_UV_MIN_MAX_detailNormalTex 55 0
//spec_const bool SC_USE_UV_MIN_MAX_emissiveTex 56 0
//spec_const bool SC_USE_UV_MIN_MAX_intensityTexture 57 0
//spec_const bool SC_USE_UV_MIN_MAX_normalTex 58 0
//spec_const bool SC_USE_UV_MIN_MAX_opacityTex 59 0
//spec_const bool SC_USE_UV_MIN_MAX_reflectionModulationTex 60 0
//spec_const bool SC_USE_UV_MIN_MAX_reflectionTex 61 0
//spec_const bool SC_USE_UV_MIN_MAX_rimColorTex 62 0
//spec_const bool SC_USE_UV_TRANSFORM_baseTex 63 0
//spec_const bool SC_USE_UV_TRANSFORM_detailNormalTex 64 0
//spec_const bool SC_USE_UV_TRANSFORM_emissiveTex 65 0
//spec_const bool SC_USE_UV_TRANSFORM_intensityTexture 66 0
//spec_const bool SC_USE_UV_TRANSFORM_normalTex 67 0
//spec_const bool SC_USE_UV_TRANSFORM_opacityTex 68 0
//spec_const bool SC_USE_UV_TRANSFORM_reflectionModulationTex 69 0
//spec_const bool SC_USE_UV_TRANSFORM_reflectionTex 70 0
//spec_const bool SC_USE_UV_TRANSFORM_rimColorTex 71 0
//spec_const bool Tweak_N179 72 0
//spec_const bool UseViewSpaceDepthVariant 73 1
//spec_const bool baseTexHasSwappedViews 74 0
//spec_const bool detailNormalTexHasSwappedViews 75 0
//spec_const bool emissiveTexHasSwappedViews 76 0
//spec_const bool intensityTextureHasSwappedViews 77 0
//spec_const bool normalTexHasSwappedViews 78 0
//spec_const bool opacityTexHasSwappedViews 79 0
//spec_const bool reflectionModulationTexHasSwappedViews 80 0
//spec_const bool reflectionTexHasSwappedViews 81 0
//spec_const bool rimColorTexHasSwappedViews 82 0
//spec_const bool sc_BlendMode_Add 83 0
//spec_const bool sc_BlendMode_AddWithAlphaFactor 84 0
//spec_const bool sc_BlendMode_AlphaTest 85 0
//spec_const bool sc_BlendMode_AlphaToCoverage 86 0
//spec_const bool sc_BlendMode_ColoredGlass 87 0
//spec_const bool sc_BlendMode_Custom 88 0
//spec_const bool sc_BlendMode_Max 89 0
//spec_const bool sc_BlendMode_Min 90 0
//spec_const bool sc_BlendMode_Multiply 91 0
//spec_const bool sc_BlendMode_MultiplyOriginal 92 0
//spec_const bool sc_BlendMode_Normal 93 0
//spec_const bool sc_BlendMode_PremultipliedAlpha 94 0
//spec_const bool sc_BlendMode_PremultipliedAlphaAuto 95 0
//spec_const bool sc_BlendMode_PremultipliedAlphaHardware 96 0
//spec_const bool sc_BlendMode_Screen 97 0
//spec_const bool sc_DepthOnly 98 0
//spec_const bool sc_FramebufferFetch 99 0
//spec_const bool sc_MotionVectorsPass 100 0
//spec_const bool sc_OITCompositingPass 101 0
//spec_const bool sc_OITDepthBoundsPass 102 0
//spec_const bool sc_OITDepthGatherPass 103 0
//spec_const bool sc_OITDepthPrepass 104 0
//spec_const bool sc_OITFrontLayerPass 105 0
//spec_const bool sc_OITMaxLayers4Plus1 106 0
//spec_const bool sc_OITMaxLayers8 107 0
//spec_const bool sc_OITMaxLayersVisualizeLayerCount 108 0
//spec_const bool sc_OutputBounds 109 0
//spec_const bool sc_ProjectiveShadowsCaster 110 0
//spec_const bool sc_ProjectiveShadowsReceiver 111 0
//spec_const bool sc_RayTracingCasterForceOpaque 112 0
//spec_const bool sc_RenderAlphaToColor 113 0
//spec_const bool sc_ScreenTextureHasSwappedViews 114 0
//spec_const bool sc_TAAEnabled 115 0
//spec_const bool sc_VertexBlending 116 0
//spec_const bool sc_VertexBlendingUseNormals 117 0
//spec_const bool sc_Voxelization 118 0
//spec_const int NODE_13_DROPLIST_ITEM 119 0
//spec_const int NODE_181_DROPLIST_ITEM 120 0
//spec_const int NODE_184_DROPLIST_ITEM 121 0
//spec_const int NODE_228_DROPLIST_ITEM 122 0
//spec_const int NODE_27_DROPLIST_ITEM 123 0
//spec_const int NODE_315_DROPLIST_ITEM 124 0
//spec_const int NODE_38_DROPLIST_ITEM 125 0
//spec_const int NODE_49_DROPLIST_ITEM 126 0
//spec_const int NODE_69_DROPLIST_ITEM 127 0
//spec_const int NODE_76_DROPLIST_ITEM 128 0
//spec_const int SC_DEVICE_CLASS 129 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_baseTex 130 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_detailNormalTex 131 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_emissiveTex 132 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_intensityTexture 133 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_normalTex 134 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_opacityTex 135 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex 136 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_reflectionTex 137 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_rimColorTex 138 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_baseTex 139 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_detailNormalTex 140 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_emissiveTex 141 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_intensityTexture 142 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_normalTex 143 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_opacityTex 144 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex 145 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_reflectionTex 146 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_rimColorTex 147 -1
//spec_const int baseTexLayout 148 0
//spec_const int detailNormalTexLayout 149 0
//spec_const int emissiveTexLayout 150 0
//spec_const int intensityTextureLayout 151 0
//spec_const int normalTexLayout 152 0
//spec_const int opacityTexLayout 153 0
//spec_const int reflectionModulationTexLayout 154 0
//spec_const int reflectionTexLayout 155 0
//spec_const int rimColorTexLayout 156 0
//spec_const int sc_DepthBufferMode 157 0
//spec_const int sc_RenderingSpace 158 -1
//spec_const int sc_ScreenTextureLayout 159 0
//spec_const int sc_ShaderCacheConstant 160 0
//spec_const int sc_SkinBonesCount 161 0
//spec_const int sc_StereoRenderingMode 162 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 163 0
//spec_const int sc_StereoViewID 164 0
//SG_REFLECTION_END
#define sc_StereoRendering_Disabled 0
#define sc_StereoRendering_InstancedClipped 1
#define sc_StereoRendering_Multiview 2
#ifdef VERTEX_SHADER
#define scOutPos(clipPosition) gl_Position=clipPosition
#define MAIN main
#endif
#ifdef SC_ENABLE_INSTANCED_RENDERING
#ifndef sc_EnableInstancing
#define sc_EnableInstancing 1
#endif
#endif
#define mod(x,y) (x-y*floor((x+1e-6)/y))
#if __VERSION__<300
#define isinf(x) (x!=0.0&&x*2.0==x ? true : false)
#define isnan(x) (x>0.0||x<0.0||x==0.0 ? false : true)
#define inverse(M) M
#endif
#ifdef sc_EnableStereoClipDistance
#if defined(GL_APPLE_clip_distance)
#extension GL_APPLE_clip_distance : require
#elif defined(GL_EXT_clip_cull_distance)
#extension GL_EXT_clip_cull_distance : require
#else
#error Clip distance is requested but not supported by this device.
#endif
#endif
#ifdef sc_EnableMultiviewStereoRendering
#define sc_StereoRenderingMode sc_StereoRendering_Multiview
#define sc_NumStereoViews 2
#extension GL_OVR_multiview2 : require
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID sc_GlobalInstanceID
#define sc_StereoViewID int(gl_ViewID_OVR)
#endif
#elif defined(sc_EnableInstancedClippedStereoRendering)
#ifndef sc_EnableInstancing
#error Instanced-clipped stereo rendering requires enabled instancing.
#endif
#ifndef sc_EnableStereoClipDistance
#define sc_StereoRendering_IsClipDistanceEnabled 0
#else
#define sc_StereoRendering_IsClipDistanceEnabled 1
#endif
#define sc_StereoRenderingMode sc_StereoRendering_InstancedClipped
#define sc_NumStereoClipPlanes 1
#define sc_NumStereoViews 2
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID (sc_GlobalInstanceID/2)
#define sc_StereoViewID (sc_GlobalInstanceID%2)
#endif
#else
#define sc_StereoRenderingMode sc_StereoRendering_Disabled
#endif
#if defined(sc_EnableInstancing)&&defined(VERTEX_SHADER)
#ifdef GL_ARB_draw_instanced
#extension GL_ARB_draw_instanced : require
#define gl_InstanceID gl_InstanceIDARB
#endif
#ifdef GL_EXT_draw_instanced
#extension GL_EXT_draw_instanced : require
#define gl_InstanceID gl_InstanceIDEXT
#endif
#ifndef sc_InstanceID
#define sc_InstanceID gl_InstanceID
#endif
#ifndef sc_GlobalInstanceID
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID)
#define sc_LocalInstanceID (sc_FallbackInstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#define sc_LocalInstanceID gl_InstanceID
#endif
#endif
#endif
#ifndef GL_ES
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable
#define precision
#define lowp
#define mediump
#define highp
#define sc_FragmentPrecision
#endif
#ifdef GL_ES
#ifdef sc_FramebufferFetch
#if defined(GL_EXT_shader_framebuffer_fetch)
#extension GL_EXT_shader_framebuffer_fetch : require
#elif defined(GL_ARM_shader_framebuffer_fetch)
#extension GL_ARM_shader_framebuffer_fetch : require
#else
#error Framebuffer fetch is requested but not supported by this device.
#endif
#endif
#ifdef GL_FRAGMENT_PRECISION_HIGH
#define sc_FragmentPrecision highp
#else
#define sc_FragmentPrecision mediump
#endif
#ifdef FRAGMENT_SHADER
precision highp int;
precision highp float;
#endif
#endif
#ifdef VERTEX_SHADER
#ifdef sc_EnableMultiviewStereoRendering
layout(num_views=sc_NumStereoViews) in;
#endif
#endif
#define SC_INT_FALLBACK_FLOAT int
#define SC_INTERPOLATION_FLAT flat
#define SC_INTERPOLATION_CENTROID centroid
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_TextureRenderingLayout_Regular
#define sc_TextureRenderingLayout_Regular 0
#define sc_TextureRenderingLayout_StereoInstancedClipped 1
#define sc_TextureRenderingLayout_StereoMultiview 2
#endif
#if defined VERTEX_SHADER
struct sc_Vertex_t
{
vec4 position;
vec3 normal;
vec3 tangent;
vec2 texture0;
vec2 texture1;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_RenderingSpace
#define sc_RenderingSpace -1
#endif
#ifndef sc_TAAEnabled
#define sc_TAAEnabled 0
#elif sc_TAAEnabled==1
#undef sc_TAAEnabled
#define sc_TAAEnabled 1
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_SkinBonesCount
#define sc_SkinBonesCount 0
#endif
#ifndef sc_VertexBlending
#define sc_VertexBlending 0
#elif sc_VertexBlending==1
#undef sc_VertexBlending
#define sc_VertexBlending 1
#endif
#ifndef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 0
#elif sc_VertexBlendingUseNormals==1
#undef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 1
#endif
#ifndef sc_DepthBufferMode
#define sc_DepthBufferMode 0
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef sc_Voxelization
#define sc_Voxelization 0
#elif sc_Voxelization==1
#undef sc_Voxelization
#define sc_Voxelization 1
#endif
#ifndef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#elif UseViewSpaceDepthVariant==1
#undef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#endif
#ifndef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 0
#elif sc_OITDepthGatherPass==1
#undef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 1
#endif
#ifndef sc_OITCompositingPass
#define sc_OITCompositingPass 0
#elif sc_OITCompositingPass==1
#undef sc_OITCompositingPass
#define sc_OITCompositingPass 1
#endif
#ifndef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 0
#elif sc_OITDepthBoundsPass==1
#undef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 1
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
#ifndef sc_OutputBounds
#define sc_OutputBounds 0
#elif sc_OutputBounds==1
#undef sc_OutputBounds
#define sc_OutputBounds 1
#endif
layout(binding=0,std430) readonly buffer sc_RayTracingCasterIndexBuffer
{
uint sc_RayTracingCasterTriangles[1];
} sc_RayTracingCasterIndexBuffer_obj;
layout(binding=1,std430) readonly buffer sc_RayTracingCasterVertexBuffer
{
float sc_RayTracingCasterVertices[1];
} sc_RayTracingCasterVertexBuffer_obj;
layout(binding=2,std430) readonly buffer sc_RayTracingCasterNonAnimatedVertexBuffer
{
float sc_RayTracingCasterNonAnimatedVertices[1];
} sc_RayTracingCasterNonAnimatedVertexBuffer_obj;
uniform mat4 sc_ModelMatrix;
uniform mat4 sc_ProjectorMatrix;
uniform vec2 sc_TAAJitterOffset;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_PrevFrameViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_PrevFrameModelMatrix;
uniform mat4 sc_ModelMatrixInverse;
uniform int sc_FallbackInstanceID;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform vec4 sc_BoneMatrices[(sc_SkinBonesCount*3)+1];
uniform mat3 sc_SkinBonesNormalMatrices[sc_SkinBonesCount+1];
uniform vec4 weights0;
uniform vec4 weights1;
uniform mat4 sc_ProjectionMatrixInverseArray[sc_NumStereoViews];
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform vec4 voxelization_params_0;
uniform vec4 voxelization_params_frustum_lrbt;
uniform vec4 voxelization_params_frustum_nf;
uniform vec3 voxelization_params_camera_pos;
uniform mat4 sc_ModelMatrixVoxelization;
uniform mat3 sc_NormalMatrix;
uniform int PreviewEnabled;
uniform uvec4 sc_RayTracingCasterConfiguration;
uniform float depthRef;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 boneData;
in vec3 blendShape0Pos;
in vec3 blendShape0Normal;
in vec3 blendShape1Pos;
in vec3 blendShape1Normal;
in vec3 blendShape2Pos;
in vec3 blendShape2Normal;
in vec3 blendShape3Pos;
in vec3 blendShape4Pos;
in vec3 blendShape5Pos;
in vec4 position;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
out vec4 varScreenPos;
out vec4 varTex01;
out vec4 varTangent;
out vec4 varColor;
in vec4 color;
out float varViewSpaceDepth;
out vec2 varShadowTex;
out vec4 PreviewVertexColor;
out float PreviewVertexSaved;
out vec2 varScreenTexturePos;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void sc_SetClipDistance(float dstClipDistance)
{
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(dstClipDistance);
}
#else
{
varClipDistance=dstClipDistance;
}
#endif
}
void sc_SetClipDistance(vec4 clipPosition)
{
#if (sc_StereoRenderingMode==1)
{
sc_SetClipDistance(dot(clipPosition,sc_StereoClipPlanes[sc_StereoViewID]));
}
#endif
}
void sc_SetClipPosition(vec4 clipPosition)
{
#if (sc_ShaderCacheConstant!=0)
{
clipPosition.x+=(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
sc_SetClipDistance(clipPosition);
gl_Position=clipPosition;
}
int sc_GetLocalInstanceIDInternal(int id)
{
#ifdef sc_LocalInstanceID
return sc_LocalInstanceID;
#else
return 0;
#endif
}
void blendTargetShapeWithNormal(inout sc_Vertex_t v,vec3 position_1,vec3 normal_1,float weight)
{
vec3 l9_0=v.position.xyz+(position_1*weight);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
v.normal+=(normal_1*weight);
}
void sc_BlendVertex(inout sc_Vertex_t v)
{
#if (sc_VertexBlending)
{
#if (sc_VertexBlendingUseNormals)
{
blendTargetShapeWithNormal(v,blendShape0Pos,blendShape0Normal,weights0.x);
blendTargetShapeWithNormal(v,blendShape1Pos,blendShape1Normal,weights0.y);
blendTargetShapeWithNormal(v,blendShape2Pos,blendShape2Normal,weights0.z);
}
#else
{
vec3 l9_0=v.position.xyz+(blendShape0Pos*weights0.x);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_1=v.position.xyz+(blendShape1Pos*weights0.y);
v=sc_Vertex_t(vec4(l9_1.x,l9_1.y,l9_1.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_2=v.position.xyz+(blendShape2Pos*weights0.z);
v=sc_Vertex_t(vec4(l9_2.x,l9_2.y,l9_2.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_3=v.position.xyz+(blendShape3Pos*weights0.w);
v=sc_Vertex_t(vec4(l9_3.x,l9_3.y,l9_3.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_4=v.position.xyz+(blendShape4Pos*weights1.x);
v=sc_Vertex_t(vec4(l9_4.x,l9_4.y,l9_4.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_5=v.position.xyz+(blendShape5Pos*weights1.y);
v=sc_Vertex_t(vec4(l9_5.x,l9_5.y,l9_5.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
}
#endif
}
#endif
}
vec4 sc_GetBoneWeights()
{
vec4 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 l9_1=vec4(1.0,fract(boneData.yzw));
vec4 l9_2=l9_1;
l9_2.x=1.0-dot(l9_1.yzw,vec3(1.0));
l9_0=l9_2;
}
#else
{
l9_0=vec4(0.0);
}
#endif
return l9_0;
}
void sc_GetBoneMatrix(int index,out vec4 m0,out vec4 m1,out vec4 m2)
{
int l9_0=3*index;
m0=sc_BoneMatrices[l9_0];
m1=sc_BoneMatrices[l9_0+1];
m2=sc_BoneMatrices[l9_0+2];
}
vec3 skinVertexPosition(int i,vec4 v)
{
vec3 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 param_1;
vec4 param_2;
vec4 param_3;
sc_GetBoneMatrix(i,param_1,param_2,param_3);
l9_0=vec3(dot(v,param_1),dot(v,param_2),dot(v,param_3));
}
#else
{
l9_0=v.xyz;
}
#endif
return l9_0;
}
void sc_SkinVertex(inout sc_Vertex_t v)
{
#if (sc_SkinBonesCount>0)
{
vec4 l9_0=sc_GetBoneWeights();
int l9_1=int(boneData.x);
int l9_2=int(boneData.y);
int l9_3=int(boneData.z);
int l9_4=int(boneData.w);
float l9_5=l9_0.x;
float l9_6=l9_0.y;
float l9_7=l9_0.z;
float l9_8=l9_0.w;
vec3 l9_9=(((skinVertexPosition(l9_1,v.position)*l9_5)+(skinVertexPosition(l9_2,v.position)*l9_6))+(skinVertexPosition(l9_3,v.position)*l9_7))+(skinVertexPosition(l9_4,v.position)*l9_8);
v.position=vec4(l9_9.x,l9_9.y,l9_9.z,v.position.w);
v.normal=((((sc_SkinBonesNormalMatrices[l9_1]*v.normal)*l9_5)+((sc_SkinBonesNormalMatrices[l9_2]*v.normal)*l9_6))+((sc_SkinBonesNormalMatrices[l9_3]*v.normal)*l9_7))+((sc_SkinBonesNormalMatrices[l9_4]*v.normal)*l9_8);
v.tangent=((((sc_SkinBonesNormalMatrices[l9_1]*v.tangent)*l9_5)+((sc_SkinBonesNormalMatrices[l9_2]*v.tangent)*l9_6))+((sc_SkinBonesNormalMatrices[l9_3]*v.tangent)*l9_7))+((sc_SkinBonesNormalMatrices[l9_4]*v.tangent)*l9_8);
}
#endif
}
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=sc_StereoViewID;
}
#endif
return l9_0;
}
mat4 createVoxelOrthoMatrix(float left,float right,float bottom,float top,float near,float far)
{
return mat4(vec4(2.0/(right-left),0.0,0.0,(-(right+left))/(right-left)),vec4(0.0,2.0/(top-bottom),0.0,(-(top+bottom))/(top-bottom)),vec4(0.0,0.0,(-2.0)/(far-near),(-(far+near))/(far-near)),vec4(0.0,0.0,0.0,1.0));
}
void main()
{
if (sc_RayTracingCasterConfiguration.x!=0u)
{
sc_SetClipPosition(vec4(position.xy,depthRef+(1e-10*position.z),1.0+(1e-10*position.w)));
return;
}
PreviewVertexColor=vec4(0.5);
PreviewVertexSaved=0.0;
sc_Vertex_t l9_0=sc_Vertex_t(position,normal,tangent.xyz,texture0,texture1);
sc_BlendVertex(l9_0);
sc_SkinVertex(l9_0);
#if (sc_RenderingSpace==3)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==4)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_0.position.x,l9_0.position.y,l9_0.position.z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_1=sc_ModelMatrix*l9_0.position;
varPosAndMotion=vec4(l9_1.x,l9_1.y,l9_1.z,varPosAndMotion.w);
vec3 l9_2=sc_NormalMatrix*l9_0.normal;
varNormalAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varNormalAndMotion.w);
vec3 l9_3=sc_NormalMatrix*l9_0.tangent;
varTangent=vec4(l9_3.x,l9_3.y,l9_3.z,varTangent.w);
}
#endif
}
#endif
}
#endif
}
#endif
bool l9_4=PreviewEnabled==1;
vec2 l9_5;
if (l9_4)
{
vec2 l9_6=l9_0.texture0;
l9_6.x=1.0-l9_0.texture0.x;
l9_5=l9_6;
}
else
{
l9_5=l9_0.texture0;
}
varColor=color;
vec3 l9_7;
vec3 l9_8;
vec3 l9_9;
if (l9_4)
{
l9_9=varTangent.xyz;
l9_8=varNormalAndMotion.xyz;
l9_7=varPosAndMotion.xyz;
}
else
{
l9_9=varTangent.xyz;
l9_8=varNormalAndMotion.xyz;
l9_7=varPosAndMotion.xyz;
}
varPosAndMotion=vec4(l9_7.x,l9_7.y,l9_7.z,varPosAndMotion.w);
vec3 l9_10=normalize(l9_8);
varNormalAndMotion=vec4(l9_10.x,l9_10.y,l9_10.z,varNormalAndMotion.w);
vec3 l9_11=normalize(l9_9);
varTangent=vec4(l9_11.x,l9_11.y,l9_11.z,varTangent.w);
varTangent.w=tangent.w;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
vec4 l9_12;
#if (sc_RenderingSpace==3)
{
l9_12=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_0.position;
}
#else
{
vec4 l9_13;
#if (sc_RenderingSpace==2)
{
l9_13=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_0.position;
}
#else
{
vec4 l9_14;
#if (sc_RenderingSpace==1)
{
l9_14=sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_0.position;
}
#else
{
l9_14=l9_0.position;
}
#endif
l9_13=l9_14;
}
#endif
l9_12=l9_13;
}
#endif
varViewSpaceDepth=-l9_12.z;
}
#endif
vec4 l9_15;
#if (sc_RenderingSpace==3)
{
l9_15=l9_0.position;
}
#else
{
vec4 l9_16;
#if (sc_RenderingSpace==4)
{
l9_16=(sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_0.position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0);
}
#else
{
vec4 l9_17;
#if (sc_RenderingSpace==2)
{
l9_17=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
vec4 l9_18;
#if (sc_RenderingSpace==1)
{
l9_18=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
l9_18=vec4(0.0);
}
#endif
l9_17=l9_18;
}
#endif
l9_16=l9_17;
}
#endif
l9_15=l9_16;
}
#endif
varTex01=vec4(l9_5,l9_0.texture1);
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_19;
#if (sc_RenderingSpace==1)
{
l9_19=sc_ModelMatrix*l9_0.position;
}
#else
{
l9_19=l9_0.position;
}
#endif
vec4 l9_20=sc_ProjectorMatrix*l9_19;
varShadowTex=((l9_20.xy/vec2(l9_20.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_21;
#if (sc_DepthBufferMode==1)
{
vec4 l9_22;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_23=l9_15;
l9_23.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_15.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_15.w;
l9_22=l9_23;
}
else
{
l9_22=l9_15;
}
l9_21=l9_22;
}
#else
{
l9_21=l9_15;
}
#endif
vec4 l9_24;
#if (sc_TAAEnabled)
{
vec2 l9_25=l9_21.xy+(sc_TAAJitterOffset*l9_21.w);
l9_24=vec4(l9_25.x,l9_25.y,l9_21.z,l9_21.w);
}
#else
{
l9_24=l9_21;
}
#endif
sc_SetClipPosition(l9_24);
#if (sc_Voxelization)
{
sc_Vertex_t l9_26=sc_Vertex_t(l9_0.position,l9_0.normal,l9_0.tangent,l9_5,l9_0.texture1);
sc_BlendVertex(l9_26);
sc_SkinVertex(l9_26);
int l9_27=sc_GetLocalInstanceIDInternal(sc_FallbackInstanceID);
int l9_28=int(voxelization_params_0.w);
vec4 l9_29=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(((sc_ModelMatrixVoxelization*l9_26.position).xyz+vec3(float(l9_27%l9_28)*voxelization_params_0.y,float(l9_27/l9_28)*voxelization_params_0.y,(float(l9_27)*(voxelization_params_0.y/voxelization_params_0.z))+voxelization_params_frustum_nf.x))-voxelization_params_camera_pos,1.0);
l9_29.w=1.0;
varScreenPos=l9_29;
sc_SetClipPosition(l9_29*1.0);
}
#else
{
#if (sc_OutputBounds)
{
sc_Vertex_t l9_30=sc_Vertex_t(l9_0.position,l9_0.normal,l9_0.tangent,l9_5,l9_0.texture1);
sc_BlendVertex(l9_30);
sc_SkinVertex(l9_30);
vec2 l9_31=((l9_30.position.xy/vec2(l9_30.position.w))*0.5)+vec2(0.5);
varTex01=vec4(l9_31.x,l9_31.y,varTex01.z,varTex01.w);
vec4 l9_32=sc_ModelMatrixVoxelization*l9_30.position;
vec3 l9_33=l9_32.xyz-voxelization_params_camera_pos;
varPosAndMotion=vec4(l9_33.x,l9_33.y,l9_33.z,varPosAndMotion.w);
vec3 l9_34=normalize(l9_30.normal);
varNormalAndMotion=vec4(l9_34.x,l9_34.y,l9_34.z,varNormalAndMotion.w);
vec4 l9_35=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(l9_33.x,l9_33.y,l9_33.z,l9_32.w);
vec4 l9_36=vec4(l9_35.x,l9_35.y,l9_35.z,vec4(0.0).w);
l9_36.w=1.0;
varScreenPos=l9_36;
sc_SetClipPosition(l9_36*1.0);
}
#endif
}
#endif
vec4 l9_37=varPosAndMotion;
#if (sc_MotionVectorsPass)
{
vec4 l9_38=vec4(l9_37.xyz,1.0);
#if (sc_MotionVectorsPass)
{
vec4 l9_39=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_38;
vec4 l9_40=sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(((sc_PrevFrameModelMatrix*sc_ModelMatrixInverse)*l9_38).xyz,1.0);
vec2 l9_41=((l9_39.xy/vec2(l9_39.w)).xy-(l9_40.xy/vec2(l9_40.w)).xy)*0.5;
varPosAndMotion.w=l9_41.x;
varNormalAndMotion.w=l9_41.y;
}
#endif
}
#endif
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
struct sc_RayTracingHitPayload
{
vec3 viewDirWS;
vec3 positionWS;
vec3 normalWS;
vec4 tangentWS;
vec4 color;
vec2 uv0;
vec2 uv1;
vec2 uv2;
vec2 uv3;
uvec2 id;
};
struct ssGlobals
{
float gTimeElapsed;
float gTimeDelta;
float gTimeElapsedShifted;
vec4 VertexColor;
vec2 Surface_UVCoord0;
vec2 Surface_UVCoord1;
vec2 gScreenCoord;
vec3 ViewDirWS;
vec3 SurfacePosition_WorldSpace;
vec3 VertexTangent_WorldSpace;
vec3 VertexNormal_WorldSpace;
vec3 VertexBinormal_WorldSpace;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 0
#elif sc_ScreenTextureHasSwappedViews==1
#undef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 1
#endif
#ifndef sc_ScreenTextureLayout
#define sc_ScreenTextureLayout 0
#endif
#ifndef sc_BlendMode_Normal
#define sc_BlendMode_Normal 0
#elif sc_BlendMode_Normal==1
#undef sc_BlendMode_Normal
#define sc_BlendMode_Normal 1
#endif
#ifndef sc_BlendMode_AlphaToCoverage
#define sc_BlendMode_AlphaToCoverage 0
#elif sc_BlendMode_AlphaToCoverage==1
#undef sc_BlendMode_AlphaToCoverage
#define sc_BlendMode_AlphaToCoverage 1
#endif
#ifndef sc_BlendMode_PremultipliedAlphaHardware
#define sc_BlendMode_PremultipliedAlphaHardware 0
#elif sc_BlendMode_PremultipliedAlphaHardware==1
#undef sc_BlendMode_PremultipliedAlphaHardware
#define sc_BlendMode_PremultipliedAlphaHardware 1
#endif
#ifndef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 0
#elif sc_BlendMode_PremultipliedAlphaAuto==1
#undef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 1
#endif
#ifndef sc_BlendMode_PremultipliedAlpha
#define sc_BlendMode_PremultipliedAlpha 0
#elif sc_BlendMode_PremultipliedAlpha==1
#undef sc_BlendMode_PremultipliedAlpha
#define sc_BlendMode_PremultipliedAlpha 1
#endif
#ifndef sc_BlendMode_AddWithAlphaFactor
#define sc_BlendMode_AddWithAlphaFactor 0
#elif sc_BlendMode_AddWithAlphaFactor==1
#undef sc_BlendMode_AddWithAlphaFactor
#define sc_BlendMode_AddWithAlphaFactor 1
#endif
#ifndef sc_BlendMode_AlphaTest
#define sc_BlendMode_AlphaTest 0
#elif sc_BlendMode_AlphaTest==1
#undef sc_BlendMode_AlphaTest
#define sc_BlendMode_AlphaTest 1
#endif
#ifndef sc_BlendMode_Multiply
#define sc_BlendMode_Multiply 0
#elif sc_BlendMode_Multiply==1
#undef sc_BlendMode_Multiply
#define sc_BlendMode_Multiply 1
#endif
#ifndef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 0
#elif sc_BlendMode_MultiplyOriginal==1
#undef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 1
#endif
#ifndef sc_BlendMode_ColoredGlass
#define sc_BlendMode_ColoredGlass 0
#elif sc_BlendMode_ColoredGlass==1
#undef sc_BlendMode_ColoredGlass
#define sc_BlendMode_ColoredGlass 1
#endif
#ifndef sc_BlendMode_Add
#define sc_BlendMode_Add 0
#elif sc_BlendMode_Add==1
#undef sc_BlendMode_Add
#define sc_BlendMode_Add 1
#endif
#ifndef sc_BlendMode_Screen
#define sc_BlendMode_Screen 0
#elif sc_BlendMode_Screen==1
#undef sc_BlendMode_Screen
#define sc_BlendMode_Screen 1
#endif
#ifndef sc_BlendMode_Min
#define sc_BlendMode_Min 0
#elif sc_BlendMode_Min==1
#undef sc_BlendMode_Min
#define sc_BlendMode_Min 1
#endif
#ifndef sc_BlendMode_Max
#define sc_BlendMode_Max 0
#elif sc_BlendMode_Max==1
#undef sc_BlendMode_Max
#define sc_BlendMode_Max 1
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#ifndef sc_RayTracingCasterForceOpaque
#define sc_RayTracingCasterForceOpaque 0
#elif sc_RayTracingCasterForceOpaque==1
#undef sc_RayTracingCasterForceOpaque
#define sc_RayTracingCasterForceOpaque 1
#endif
#ifndef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 0
#elif intensityTextureHasSwappedViews==1
#undef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 1
#endif
#ifndef BLEND_MODE_REALISTIC
#define BLEND_MODE_REALISTIC 0
#elif BLEND_MODE_REALISTIC==1
#undef BLEND_MODE_REALISTIC
#define BLEND_MODE_REALISTIC 1
#endif
#ifndef BLEND_MODE_FORGRAY
#define BLEND_MODE_FORGRAY 0
#elif BLEND_MODE_FORGRAY==1
#undef BLEND_MODE_FORGRAY
#define BLEND_MODE_FORGRAY 1
#endif
#ifndef BLEND_MODE_NOTBRIGHT
#define BLEND_MODE_NOTBRIGHT 0
#elif BLEND_MODE_NOTBRIGHT==1
#undef BLEND_MODE_NOTBRIGHT
#define BLEND_MODE_NOTBRIGHT 1
#endif
#ifndef BLEND_MODE_DIVISION
#define BLEND_MODE_DIVISION 0
#elif BLEND_MODE_DIVISION==1
#undef BLEND_MODE_DIVISION
#define BLEND_MODE_DIVISION 1
#endif
#ifndef BLEND_MODE_BRIGHT
#define BLEND_MODE_BRIGHT 0
#elif BLEND_MODE_BRIGHT==1
#undef BLEND_MODE_BRIGHT
#define BLEND_MODE_BRIGHT 1
#endif
#ifndef BLEND_MODE_INTENSE
#define BLEND_MODE_INTENSE 0
#elif BLEND_MODE_INTENSE==1
#undef BLEND_MODE_INTENSE
#define BLEND_MODE_INTENSE 1
#endif
#ifndef intensityTextureLayout
#define intensityTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 0
#elif SC_USE_UV_TRANSFORM_intensityTexture==1
#undef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_U_intensityTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_V_intensityTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 0
#elif SC_USE_UV_MIN_MAX_intensityTexture==1
#undef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 0
#elif SC_USE_CLAMP_TO_BORDER_intensityTexture==1
#undef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 1
#endif
#ifndef BLEND_MODE_LIGHTEN
#define BLEND_MODE_LIGHTEN 0
#elif BLEND_MODE_LIGHTEN==1
#undef BLEND_MODE_LIGHTEN
#define BLEND_MODE_LIGHTEN 1
#endif
#ifndef BLEND_MODE_DARKEN
#define BLEND_MODE_DARKEN 0
#elif BLEND_MODE_DARKEN==1
#undef BLEND_MODE_DARKEN
#define BLEND_MODE_DARKEN 1
#endif
#ifndef BLEND_MODE_DIVIDE
#define BLEND_MODE_DIVIDE 0
#elif BLEND_MODE_DIVIDE==1
#undef BLEND_MODE_DIVIDE
#define BLEND_MODE_DIVIDE 1
#endif
#ifndef BLEND_MODE_AVERAGE
#define BLEND_MODE_AVERAGE 0
#elif BLEND_MODE_AVERAGE==1
#undef BLEND_MODE_AVERAGE
#define BLEND_MODE_AVERAGE 1
#endif
#ifndef BLEND_MODE_SUBTRACT
#define BLEND_MODE_SUBTRACT 0
#elif BLEND_MODE_SUBTRACT==1
#undef BLEND_MODE_SUBTRACT
#define BLEND_MODE_SUBTRACT 1
#endif
#ifndef BLEND_MODE_DIFFERENCE
#define BLEND_MODE_DIFFERENCE 0
#elif BLEND_MODE_DIFFERENCE==1
#undef BLEND_MODE_DIFFERENCE
#define BLEND_MODE_DIFFERENCE 1
#endif
#ifndef BLEND_MODE_NEGATION
#define BLEND_MODE_NEGATION 0
#elif BLEND_MODE_NEGATION==1
#undef BLEND_MODE_NEGATION
#define BLEND_MODE_NEGATION 1
#endif
#ifndef BLEND_MODE_EXCLUSION
#define BLEND_MODE_EXCLUSION 0
#elif BLEND_MODE_EXCLUSION==1
#undef BLEND_MODE_EXCLUSION
#define BLEND_MODE_EXCLUSION 1
#endif
#ifndef BLEND_MODE_OVERLAY
#define BLEND_MODE_OVERLAY 0
#elif BLEND_MODE_OVERLAY==1
#undef BLEND_MODE_OVERLAY
#define BLEND_MODE_OVERLAY 1
#endif
#ifndef BLEND_MODE_SOFT_LIGHT
#define BLEND_MODE_SOFT_LIGHT 0
#elif BLEND_MODE_SOFT_LIGHT==1
#undef BLEND_MODE_SOFT_LIGHT
#define BLEND_MODE_SOFT_LIGHT 1
#endif
#ifndef BLEND_MODE_HARD_LIGHT
#define BLEND_MODE_HARD_LIGHT 0
#elif BLEND_MODE_HARD_LIGHT==1
#undef BLEND_MODE_HARD_LIGHT
#define BLEND_MODE_HARD_LIGHT 1
#endif
#ifndef BLEND_MODE_COLOR_DODGE
#define BLEND_MODE_COLOR_DODGE 0
#elif BLEND_MODE_COLOR_DODGE==1
#undef BLEND_MODE_COLOR_DODGE
#define BLEND_MODE_COLOR_DODGE 1
#endif
#ifndef BLEND_MODE_COLOR_BURN
#define BLEND_MODE_COLOR_BURN 0
#elif BLEND_MODE_COLOR_BURN==1
#undef BLEND_MODE_COLOR_BURN
#define BLEND_MODE_COLOR_BURN 1
#endif
#ifndef BLEND_MODE_LINEAR_LIGHT
#define BLEND_MODE_LINEAR_LIGHT 0
#elif BLEND_MODE_LINEAR_LIGHT==1
#undef BLEND_MODE_LINEAR_LIGHT
#define BLEND_MODE_LINEAR_LIGHT 1
#endif
#ifndef BLEND_MODE_VIVID_LIGHT
#define BLEND_MODE_VIVID_LIGHT 0
#elif BLEND_MODE_VIVID_LIGHT==1
#undef BLEND_MODE_VIVID_LIGHT
#define BLEND_MODE_VIVID_LIGHT 1
#endif
#ifndef BLEND_MODE_PIN_LIGHT
#define BLEND_MODE_PIN_LIGHT 0
#elif BLEND_MODE_PIN_LIGHT==1
#undef BLEND_MODE_PIN_LIGHT
#define BLEND_MODE_PIN_LIGHT 1
#endif
#ifndef BLEND_MODE_HARD_MIX
#define BLEND_MODE_HARD_MIX 0
#elif BLEND_MODE_HARD_MIX==1
#undef BLEND_MODE_HARD_MIX
#define BLEND_MODE_HARD_MIX 1
#endif
#ifndef BLEND_MODE_HARD_REFLECT
#define BLEND_MODE_HARD_REFLECT 0
#elif BLEND_MODE_HARD_REFLECT==1
#undef BLEND_MODE_HARD_REFLECT
#define BLEND_MODE_HARD_REFLECT 1
#endif
#ifndef BLEND_MODE_HARD_GLOW
#define BLEND_MODE_HARD_GLOW 0
#elif BLEND_MODE_HARD_GLOW==1
#undef BLEND_MODE_HARD_GLOW
#define BLEND_MODE_HARD_GLOW 1
#endif
#ifndef BLEND_MODE_HARD_PHOENIX
#define BLEND_MODE_HARD_PHOENIX 0
#elif BLEND_MODE_HARD_PHOENIX==1
#undef BLEND_MODE_HARD_PHOENIX
#define BLEND_MODE_HARD_PHOENIX 1
#endif
#ifndef BLEND_MODE_HUE
#define BLEND_MODE_HUE 0
#elif BLEND_MODE_HUE==1
#undef BLEND_MODE_HUE
#define BLEND_MODE_HUE 1
#endif
#ifndef BLEND_MODE_SATURATION
#define BLEND_MODE_SATURATION 0
#elif BLEND_MODE_SATURATION==1
#undef BLEND_MODE_SATURATION
#define BLEND_MODE_SATURATION 1
#endif
#ifndef BLEND_MODE_COLOR
#define BLEND_MODE_COLOR 0
#elif BLEND_MODE_COLOR==1
#undef BLEND_MODE_COLOR
#define BLEND_MODE_COLOR 1
#endif
#ifndef BLEND_MODE_LUMINOSITY
#define BLEND_MODE_LUMINOSITY 0
#elif BLEND_MODE_LUMINOSITY==1
#undef BLEND_MODE_LUMINOSITY
#define BLEND_MODE_LUMINOSITY 1
#endif
#ifndef sc_SkinBonesCount
#define sc_SkinBonesCount 0
#endif
#ifndef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#elif UseViewSpaceDepthVariant==1
#undef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#endif
#ifndef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 0
#elif sc_OITDepthGatherPass==1
#undef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 1
#endif
#ifndef sc_OITCompositingPass
#define sc_OITCompositingPass 0
#elif sc_OITCompositingPass==1
#undef sc_OITCompositingPass
#define sc_OITCompositingPass 1
#endif
#ifndef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 0
#elif sc_OITDepthBoundsPass==1
#undef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 1
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_OITMaxLayers4Plus1
#define sc_OITMaxLayers4Plus1 0
#elif sc_OITMaxLayers4Plus1==1
#undef sc_OITMaxLayers4Plus1
#define sc_OITMaxLayers4Plus1 1
#endif
#ifndef sc_OITMaxLayersVisualizeLayerCount
#define sc_OITMaxLayersVisualizeLayerCount 0
#elif sc_OITMaxLayersVisualizeLayerCount==1
#undef sc_OITMaxLayersVisualizeLayerCount
#define sc_OITMaxLayersVisualizeLayerCount 1
#endif
#ifndef sc_OITMaxLayers8
#define sc_OITMaxLayers8 0
#elif sc_OITMaxLayers8==1
#undef sc_OITMaxLayers8
#define sc_OITMaxLayers8 1
#endif
#ifndef sc_OITFrontLayerPass
#define sc_OITFrontLayerPass 0
#elif sc_OITFrontLayerPass==1
#undef sc_OITFrontLayerPass
#define sc_OITFrontLayerPass 1
#endif
#ifndef sc_OITDepthPrepass
#define sc_OITDepthPrepass 0
#elif sc_OITDepthPrepass==1
#undef sc_OITDepthPrepass
#define sc_OITDepthPrepass 1
#endif
#ifndef SC_DEVICE_CLASS
#define SC_DEVICE_CLASS -1
#endif
#ifndef ENABLE_STIPPLE_PATTERN_TEST
#define ENABLE_STIPPLE_PATTERN_TEST 0
#elif ENABLE_STIPPLE_PATTERN_TEST==1
#undef ENABLE_STIPPLE_PATTERN_TEST
#define ENABLE_STIPPLE_PATTERN_TEST 1
#endif
#ifndef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 0
#elif sc_ProjectiveShadowsCaster==1
#undef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 1
#endif
#ifndef sc_RenderAlphaToColor
#define sc_RenderAlphaToColor 0
#elif sc_RenderAlphaToColor==1
#undef sc_RenderAlphaToColor
#define sc_RenderAlphaToColor 1
#endif
#ifndef sc_BlendMode_Custom
#define sc_BlendMode_Custom 0
#elif sc_BlendMode_Custom==1
#undef sc_BlendMode_Custom
#define sc_BlendMode_Custom 1
#endif
#ifndef sc_Voxelization
#define sc_Voxelization 0
#elif sc_Voxelization==1
#undef sc_Voxelization
#define sc_Voxelization 1
#endif
#ifndef sc_OutputBounds
#define sc_OutputBounds 0
#elif sc_OutputBounds==1
#undef sc_OutputBounds
#define sc_OutputBounds 1
#endif
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef emissiveTexHasSwappedViews
#define emissiveTexHasSwappedViews 0
#elif emissiveTexHasSwappedViews==1
#undef emissiveTexHasSwappedViews
#define emissiveTexHasSwappedViews 1
#endif
#ifndef reflectionTexHasSwappedViews
#define reflectionTexHasSwappedViews 0
#elif reflectionTexHasSwappedViews==1
#undef reflectionTexHasSwappedViews
#define reflectionTexHasSwappedViews 1
#endif
#ifndef normalTexHasSwappedViews
#define normalTexHasSwappedViews 0
#elif normalTexHasSwappedViews==1
#undef normalTexHasSwappedViews
#define normalTexHasSwappedViews 1
#endif
#ifndef detailNormalTexHasSwappedViews
#define detailNormalTexHasSwappedViews 0
#elif detailNormalTexHasSwappedViews==1
#undef detailNormalTexHasSwappedViews
#define detailNormalTexHasSwappedViews 1
#endif
#ifndef reflectionModulationTexHasSwappedViews
#define reflectionModulationTexHasSwappedViews 0
#elif reflectionModulationTexHasSwappedViews==1
#undef reflectionModulationTexHasSwappedViews
#define reflectionModulationTexHasSwappedViews 1
#endif
#ifndef rimColorTexHasSwappedViews
#define rimColorTexHasSwappedViews 0
#elif rimColorTexHasSwappedViews==1
#undef rimColorTexHasSwappedViews
#define rimColorTexHasSwappedViews 1
#endif
#ifndef opacityTexHasSwappedViews
#define opacityTexHasSwappedViews 0
#elif opacityTexHasSwappedViews==1
#undef opacityTexHasSwappedViews
#define opacityTexHasSwappedViews 1
#endif
#ifndef NODE_13_DROPLIST_ITEM
#define NODE_13_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_UV2_ANIMATION
#define ENABLE_UV2_ANIMATION 0
#elif ENABLE_UV2_ANIMATION==1
#undef ENABLE_UV2_ANIMATION
#define ENABLE_UV2_ANIMATION 1
#endif
#ifndef ENABLE_UV2
#define ENABLE_UV2 0
#elif ENABLE_UV2==1
#undef ENABLE_UV2
#define ENABLE_UV2 1
#endif
#ifndef NODE_49_DROPLIST_ITEM
#define NODE_49_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_UV3_ANIMATION
#define ENABLE_UV3_ANIMATION 0
#elif ENABLE_UV3_ANIMATION==1
#undef ENABLE_UV3_ANIMATION
#define ENABLE_UV3_ANIMATION 1
#endif
#ifndef ENABLE_UV3
#define ENABLE_UV3 0
#elif ENABLE_UV3==1
#undef ENABLE_UV3
#define ENABLE_UV3 1
#endif
#ifndef NODE_27_DROPLIST_ITEM
#define NODE_27_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_BASE_TEX
#define ENABLE_BASE_TEX 0
#elif ENABLE_BASE_TEX==1
#undef ENABLE_BASE_TEX
#define ENABLE_BASE_TEX 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 0
#elif SC_USE_UV_TRANSFORM_baseTex==1
#undef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
#ifndef ENABLE_RECOLOR
#define ENABLE_RECOLOR 0
#elif ENABLE_RECOLOR==1
#undef ENABLE_RECOLOR
#define ENABLE_RECOLOR 1
#endif
#ifndef NODE_38_DROPLIST_ITEM
#define NODE_38_DROPLIST_ITEM 0
#endif
#ifndef NODE_76_DROPLIST_ITEM
#define NODE_76_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_EMISSIVE
#define ENABLE_EMISSIVE 0
#elif ENABLE_EMISSIVE==1
#undef ENABLE_EMISSIVE
#define ENABLE_EMISSIVE 1
#endif
#ifndef emissiveTexLayout
#define emissiveTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_emissiveTex
#define SC_USE_UV_TRANSFORM_emissiveTex 0
#elif SC_USE_UV_TRANSFORM_emissiveTex==1
#undef SC_USE_UV_TRANSFORM_emissiveTex
#define SC_USE_UV_TRANSFORM_emissiveTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_emissiveTex
#define SC_SOFTWARE_WRAP_MODE_U_emissiveTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_emissiveTex
#define SC_SOFTWARE_WRAP_MODE_V_emissiveTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_emissiveTex
#define SC_USE_UV_MIN_MAX_emissiveTex 0
#elif SC_USE_UV_MIN_MAX_emissiveTex==1
#undef SC_USE_UV_MIN_MAX_emissiveTex
#define SC_USE_UV_MIN_MAX_emissiveTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_emissiveTex
#define SC_USE_CLAMP_TO_BORDER_emissiveTex 0
#elif SC_USE_CLAMP_TO_BORDER_emissiveTex==1
#undef SC_USE_CLAMP_TO_BORDER_emissiveTex
#define SC_USE_CLAMP_TO_BORDER_emissiveTex 1
#endif
#ifndef NODE_181_DROPLIST_ITEM
#define NODE_181_DROPLIST_ITEM 0
#endif
#ifndef normalTexLayout
#define normalTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_normalTex
#define SC_USE_UV_TRANSFORM_normalTex 0
#elif SC_USE_UV_TRANSFORM_normalTex==1
#undef SC_USE_UV_TRANSFORM_normalTex
#define SC_USE_UV_TRANSFORM_normalTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_normalTex
#define SC_SOFTWARE_WRAP_MODE_U_normalTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_normalTex
#define SC_SOFTWARE_WRAP_MODE_V_normalTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_normalTex
#define SC_USE_UV_MIN_MAX_normalTex 0
#elif SC_USE_UV_MIN_MAX_normalTex==1
#undef SC_USE_UV_MIN_MAX_normalTex
#define SC_USE_UV_MIN_MAX_normalTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_normalTex
#define SC_USE_CLAMP_TO_BORDER_normalTex 0
#elif SC_USE_CLAMP_TO_BORDER_normalTex==1
#undef SC_USE_CLAMP_TO_BORDER_normalTex
#define SC_USE_CLAMP_TO_BORDER_normalTex 1
#endif
#ifndef NODE_184_DROPLIST_ITEM
#define NODE_184_DROPLIST_ITEM 0
#endif
#ifndef detailNormalTexLayout
#define detailNormalTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_detailNormalTex
#define SC_USE_UV_TRANSFORM_detailNormalTex 0
#elif SC_USE_UV_TRANSFORM_detailNormalTex==1
#undef SC_USE_UV_TRANSFORM_detailNormalTex
#define SC_USE_UV_TRANSFORM_detailNormalTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_detailNormalTex
#define SC_SOFTWARE_WRAP_MODE_U_detailNormalTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_detailNormalTex
#define SC_SOFTWARE_WRAP_MODE_V_detailNormalTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_detailNormalTex
#define SC_USE_UV_MIN_MAX_detailNormalTex 0
#elif SC_USE_UV_MIN_MAX_detailNormalTex==1
#undef SC_USE_UV_MIN_MAX_detailNormalTex
#define SC_USE_UV_MIN_MAX_detailNormalTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_detailNormalTex
#define SC_USE_CLAMP_TO_BORDER_detailNormalTex 0
#elif SC_USE_CLAMP_TO_BORDER_detailNormalTex==1
#undef SC_USE_CLAMP_TO_BORDER_detailNormalTex
#define SC_USE_CLAMP_TO_BORDER_detailNormalTex 1
#endif
#ifndef ENABLE_DETAIL_NORMAL
#define ENABLE_DETAIL_NORMAL 0
#elif ENABLE_DETAIL_NORMAL==1
#undef ENABLE_DETAIL_NORMAL
#define ENABLE_DETAIL_NORMAL 1
#endif
#ifndef ENABLE_NORMALMAP
#define ENABLE_NORMALMAP 0
#elif ENABLE_NORMALMAP==1
#undef ENABLE_NORMALMAP
#define ENABLE_NORMALMAP 1
#endif
#ifndef NODE_228_DROPLIST_ITEM
#define NODE_228_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_REFLECTION_MODULATION_TEX
#define ENABLE_REFLECTION_MODULATION_TEX 0
#elif ENABLE_REFLECTION_MODULATION_TEX==1
#undef ENABLE_REFLECTION_MODULATION_TEX
#define ENABLE_REFLECTION_MODULATION_TEX 1
#endif
#ifndef reflectionModulationTexLayout
#define reflectionModulationTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_reflectionModulationTex
#define SC_USE_UV_TRANSFORM_reflectionModulationTex 0
#elif SC_USE_UV_TRANSFORM_reflectionModulationTex==1
#undef SC_USE_UV_TRANSFORM_reflectionModulationTex
#define SC_USE_UV_TRANSFORM_reflectionModulationTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex
#define SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex
#define SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_reflectionModulationTex
#define SC_USE_UV_MIN_MAX_reflectionModulationTex 0
#elif SC_USE_UV_MIN_MAX_reflectionModulationTex==1
#undef SC_USE_UV_MIN_MAX_reflectionModulationTex
#define SC_USE_UV_MIN_MAX_reflectionModulationTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_reflectionModulationTex
#define SC_USE_CLAMP_TO_BORDER_reflectionModulationTex 0
#elif SC_USE_CLAMP_TO_BORDER_reflectionModulationTex==1
#undef SC_USE_CLAMP_TO_BORDER_reflectionModulationTex
#define SC_USE_CLAMP_TO_BORDER_reflectionModulationTex 1
#endif
#ifndef Tweak_N179
#define Tweak_N179 0
#elif Tweak_N179==1
#undef Tweak_N179
#define Tweak_N179 1
#endif
#ifndef reflectionTexLayout
#define reflectionTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_reflectionTex
#define SC_USE_UV_TRANSFORM_reflectionTex 0
#elif SC_USE_UV_TRANSFORM_reflectionTex==1
#undef SC_USE_UV_TRANSFORM_reflectionTex
#define SC_USE_UV_TRANSFORM_reflectionTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_reflectionTex
#define SC_SOFTWARE_WRAP_MODE_U_reflectionTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_reflectionTex
#define SC_SOFTWARE_WRAP_MODE_V_reflectionTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_reflectionTex
#define SC_USE_UV_MIN_MAX_reflectionTex 0
#elif SC_USE_UV_MIN_MAX_reflectionTex==1
#undef SC_USE_UV_MIN_MAX_reflectionTex
#define SC_USE_UV_MIN_MAX_reflectionTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_reflectionTex
#define SC_USE_CLAMP_TO_BORDER_reflectionTex 0
#elif SC_USE_CLAMP_TO_BORDER_reflectionTex==1
#undef SC_USE_CLAMP_TO_BORDER_reflectionTex
#define SC_USE_CLAMP_TO_BORDER_reflectionTex 1
#endif
#ifndef NODE_315_DROPLIST_ITEM
#define NODE_315_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_RIM_COLOR_TEX
#define ENABLE_RIM_COLOR_TEX 0
#elif ENABLE_RIM_COLOR_TEX==1
#undef ENABLE_RIM_COLOR_TEX
#define ENABLE_RIM_COLOR_TEX 1
#endif
#ifndef rimColorTexLayout
#define rimColorTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_rimColorTex
#define SC_USE_UV_TRANSFORM_rimColorTex 0
#elif SC_USE_UV_TRANSFORM_rimColorTex==1
#undef SC_USE_UV_TRANSFORM_rimColorTex
#define SC_USE_UV_TRANSFORM_rimColorTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_rimColorTex
#define SC_SOFTWARE_WRAP_MODE_U_rimColorTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_rimColorTex
#define SC_SOFTWARE_WRAP_MODE_V_rimColorTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_rimColorTex
#define SC_USE_UV_MIN_MAX_rimColorTex 0
#elif SC_USE_UV_MIN_MAX_rimColorTex==1
#undef SC_USE_UV_MIN_MAX_rimColorTex
#define SC_USE_UV_MIN_MAX_rimColorTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_rimColorTex
#define SC_USE_CLAMP_TO_BORDER_rimColorTex 0
#elif SC_USE_CLAMP_TO_BORDER_rimColorTex==1
#undef SC_USE_CLAMP_TO_BORDER_rimColorTex
#define SC_USE_CLAMP_TO_BORDER_rimColorTex 1
#endif
#ifndef ENABLE_RIM_INVERT
#define ENABLE_RIM_INVERT 0
#elif ENABLE_RIM_INVERT==1
#undef ENABLE_RIM_INVERT
#define ENABLE_RIM_INVERT 1
#endif
#ifndef ENABLE_RIM_HIGHLIGHT
#define ENABLE_RIM_HIGHLIGHT 0
#elif ENABLE_RIM_HIGHLIGHT==1
#undef ENABLE_RIM_HIGHLIGHT
#define ENABLE_RIM_HIGHLIGHT 1
#endif
#ifndef NODE_69_DROPLIST_ITEM
#define NODE_69_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_OPACITY_TEX
#define ENABLE_OPACITY_TEX 0
#elif ENABLE_OPACITY_TEX==1
#undef ENABLE_OPACITY_TEX
#define ENABLE_OPACITY_TEX 1
#endif
#ifndef opacityTexLayout
#define opacityTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_opacityTex
#define SC_USE_UV_TRANSFORM_opacityTex 0
#elif SC_USE_UV_TRANSFORM_opacityTex==1
#undef SC_USE_UV_TRANSFORM_opacityTex
#define SC_USE_UV_TRANSFORM_opacityTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_opacityTex
#define SC_SOFTWARE_WRAP_MODE_U_opacityTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_opacityTex
#define SC_SOFTWARE_WRAP_MODE_V_opacityTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_opacityTex
#define SC_USE_UV_MIN_MAX_opacityTex 0
#elif SC_USE_UV_MIN_MAX_opacityTex==1
#undef SC_USE_UV_MIN_MAX_opacityTex
#define SC_USE_UV_MIN_MAX_opacityTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_opacityTex
#define SC_USE_CLAMP_TO_BORDER_opacityTex 0
#elif SC_USE_CLAMP_TO_BORDER_opacityTex==1
#undef SC_USE_CLAMP_TO_BORDER_opacityTex
#define SC_USE_CLAMP_TO_BORDER_opacityTex 1
#endif
#ifndef sc_DepthOnly
#define sc_DepthOnly 0
#elif sc_DepthOnly==1
#undef sc_DepthOnly
#define sc_DepthOnly 1
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
layout(binding=1,std430) readonly buffer sc_RayTracingCasterVertexBuffer
{
float sc_RayTracingCasterVertices[1];
} sc_RayTracingCasterVertexBuffer_obj;
layout(binding=2,std430) readonly buffer sc_RayTracingCasterNonAnimatedVertexBuffer
{
float sc_RayTracingCasterNonAnimatedVertices[1];
} sc_RayTracingCasterNonAnimatedVertexBuffer_obj;
layout(binding=0,std430) readonly buffer sc_RayTracingCasterIndexBuffer
{
uint sc_RayTracingCasterTriangles[1];
} sc_RayTracingCasterIndexBuffer_obj;
uniform vec4 sc_CurrentRenderTargetDims;
uniform float sc_ShadowDensity;
uniform vec4 sc_ShadowColor;
uniform vec4 sc_UniformConstants;
uniform uvec4 sc_RayTracingCasterConfiguration;
uniform uvec4 sc_RayTracingCasterOffsetPNTC;
uniform uvec4 sc_RayTracingCasterFormatPNTC;
uniform uvec4 sc_RayTracingCasterOffsetTexture;
uniform uvec4 sc_RayTracingCasterFormatTexture;
uniform mat4 sc_ModelMatrix;
uniform mat3 sc_NormalMatrix;
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform float alphaTestThreshold;
uniform vec3 recolorRed;
uniform vec4 baseColor;
uniform vec2 uv2Scale;
uniform vec2 uv2Offset;
uniform float Port_Speed_N022;
uniform vec2 uv3Scale;
uniform vec2 uv3Offset;
uniform float Port_Speed_N063;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec3 recolorGreen;
uniform vec3 recolorBlue;
uniform vec4 Port_Default_N369;
uniform mat3 emissiveTexTransform;
uniform vec4 emissiveTexUvMinMax;
uniform vec4 emissiveTexBorderColor;
uniform vec3 Port_Default_N132;
uniform vec3 emissiveColor;
uniform float emissiveIntensity;
uniform float reflectionIntensity;
uniform mat3 normalTexTransform;
uniform vec4 normalTexUvMinMax;
uniform vec4 normalTexBorderColor;
uniform mat3 detailNormalTexTransform;
uniform vec4 detailNormalTexUvMinMax;
uniform vec4 detailNormalTexBorderColor;
uniform vec3 Port_Default_N113;
uniform float Port_Strength1_N200;
uniform float Port_Strength2_N200;
uniform mat3 reflectionModulationTexTransform;
uniform vec4 reflectionModulationTexUvMinMax;
uniform vec4 reflectionModulationTexBorderColor;
uniform vec3 Port_Input1_N257;
uniform float Port_Input1_N264;
uniform float Port_Input1_N268;
uniform float Port_Input1_N270;
uniform mat3 reflectionTexTransform;
uniform vec4 reflectionTexUvMinMax;
uniform vec4 reflectionTexBorderColor;
uniform vec3 Port_Default_N041;
uniform vec3 rimColor;
uniform float rimIntensity;
uniform mat3 rimColorTexTransform;
uniform vec4 rimColorTexUvMinMax;
uniform vec4 rimColorTexBorderColor;
uniform float rimExponent;
uniform vec3 Port_Default_N170;
uniform mat3 opacityTexTransform;
uniform vec4 opacityTexUvMinMax;
uniform vec4 opacityTexBorderColor;
uniform vec4 sc_Time;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform vec3 Port_Default_N097;
uniform vec3 Port_Default_N134;
uniform vec3 Port_Default_N173;
uniform float Port_Default_N204;
uniform float Port_Input2_N072;
uniform int PreviewEnabled;
uniform usampler2D sc_RayTracingHitCasterIdAndBarycentric;
uniform sampler2D sc_RayTracingRayDirection;
uniform sampler2D baseTex;
uniform sampler2DArray baseTexArrSC;
uniform sampler2D emissiveTex;
uniform sampler2DArray emissiveTexArrSC;
uniform sampler2D normalTex;
uniform sampler2DArray normalTexArrSC;
uniform sampler2D detailNormalTex;
uniform sampler2DArray detailNormalTexArrSC;
uniform sampler2D reflectionTex;
uniform sampler2DArray reflectionTexArrSC;
uniform sampler2D reflectionModulationTex;
uniform sampler2DArray reflectionModulationTexArrSC;
uniform sampler2D rimColorTex;
uniform sampler2DArray rimColorTexArrSC;
uniform sampler2D opacityTex;
uniform sampler2DArray opacityTexArrSC;
uniform sampler2D sc_ScreenTexture;
uniform sampler2DArray sc_ScreenTextureArrSC;
uniform sampler2D intensityTexture;
uniform sampler2DArray intensityTextureArrSC;
uniform sampler2D sc_OITFrontDepthTexture;
uniform sampler2D sc_OITDepthHigh0;
uniform sampler2D sc_OITDepthLow0;
uniform sampler2D sc_OITAlpha0;
uniform sampler2D sc_OITDepthHigh1;
uniform sampler2D sc_OITDepthLow1;
uniform sampler2D sc_OITAlpha1;
uniform sampler2D sc_OITFilteredDepthBoundsTexture;
flat in int varStereoViewID;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#define out inout
#endif
layout(location=0) out vec4 sc_FragData0;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#undef out
#endif
in vec4 varScreenPos;
in float varViewSpaceDepth;
in vec4 PreviewVertexColor;
in float PreviewVertexSaved;
in vec4 varColor;
in vec4 varTex01;
in vec4 varTangent;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=varStereoViewID;
}
#endif
return l9_0;
}
vec2 sc_SamplingCoordsGlobalToView(vec3 uvi,int renderingLayout,int viewIndex)
{
if (renderingLayout==1)
{
uvi.y=((2.0*uvi.y)+float(viewIndex))-1.0;
}
return uvi.xy;
}
vec2 sc_ScreenCoordsGlobalToView(vec2 uv)
{
vec2 l9_0;
#if (sc_StereoRenderingMode==1)
{
l9_0=sc_SamplingCoordsGlobalToView(vec3(uv,0.0),1,sc_GetStereoViewIndex());
}
#else
{
l9_0=uv;
}
#endif
return l9_0;
}
vec3 sc_RayTracingInterpolateAnimatedFloat3(vec3 brc,uvec3 indices,uint offset)
{
uvec3 l9_0=(indices*uvec3(6u))+uvec3(offset);
uint l9_1=l9_0.x;
uint l9_2=l9_0.y;
uint l9_3=l9_0.z;
return ((vec3(sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_1],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_1+1u],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_1+2u])*brc.x)+(vec3(sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_2],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_2+1u],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_2+2u])*brc.y))+(vec3(sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_3],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_3+1u],sc_RayTracingCasterNonAnimatedVertexBuffer_obj.sc_RayTracingCasterNonAnimatedVertices[l9_3+2u])*brc.z);
}
vec4 sc_RayTracingFetchUnorm4(uint offset)
{
uint l9_0=floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[offset]);
return vec4(float(l9_0&255u),float((l9_0>>uint(8))&255u),float((l9_0>>uint(16))&255u),float((l9_0>>uint(24))&255u))/vec4(255.0);
}
sc_RayTracingHitPayload sc_RayTracingEvaluateHitPayload(ivec2 screenPos)
{
ivec2 l9_0=screenPos;
uvec4 l9_1=texelFetch(sc_RayTracingHitCasterIdAndBarycentric,l9_0,0);
uvec2 l9_2=l9_1.xy;
if (l9_1.x!=(sc_RayTracingCasterConfiguration.y&65535u))
{
return sc_RayTracingHitPayload(vec3(0.0),vec3(0.0),vec3(0.0),vec4(0.0),vec4(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),l9_2);
}
vec2 l9_3=unpackHalf2x16(l9_1.z|(l9_1.w<<uint(16)));
float l9_4=l9_3.x;
float l9_5=l9_3.y;
float l9_6=(1.0-l9_4)-l9_5;
vec3 l9_7=vec3(l9_6,l9_4,l9_5);
ivec2 l9_8=screenPos;
vec4 l9_9=texelFetch(sc_RayTracingRayDirection,l9_8,0);
float l9_10=l9_9.x;
float l9_11=l9_9.y;
float l9_12=(1.0-abs(l9_10))-abs(l9_11);
vec3 l9_13=vec3(l9_10,l9_11,l9_12);
float l9_14=clamp(-l9_12,0.0,1.0);
float l9_15;
if (l9_10>=0.0)
{
l9_15=-l9_14;
}
else
{
l9_15=l9_14;
}
float l9_16;
if (l9_11>=0.0)
{
l9_16=-l9_14;
}
else
{
l9_16=l9_14;
}
vec2 l9_17=vec2(l9_15,l9_16);
vec2 l9_18=l9_13.xy+l9_17;
uint l9_19=min(l9_1.y,sc_RayTracingCasterConfiguration.z)*6u;
uint l9_20=l9_19&4294967292u;
uint l9_21=l9_20/4u;
uint l9_22=sc_RayTracingCasterIndexBuffer_obj.sc_RayTracingCasterTriangles[l9_21];
uint l9_23=l9_21+1u;
uint l9_24=sc_RayTracingCasterIndexBuffer_obj.sc_RayTracingCasterTriangles[l9_23];
uvec4 l9_25=(uvec4(l9_22,l9_22,l9_24,l9_24)&uvec4(65535u,4294967295u,65535u,4294967295u))>>uvec4(0u,16u,0u,16u);
uvec3 l9_26;
if (l9_19==l9_20)
{
l9_26=l9_25.xyz;
}
else
{
l9_26=l9_25.yzw;
}
bool l9_27=sc_RayTracingCasterConfiguration.x==2u;
vec3 l9_28;
if (l9_27)
{
l9_28=sc_RayTracingInterpolateAnimatedFloat3(l9_7,l9_26,0u);
}
else
{
uint l9_29=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_30=(l9_26.x*l9_29)+sc_RayTracingCasterOffsetPNTC.x;
uint l9_31=(l9_26.y*l9_29)+sc_RayTracingCasterOffsetPNTC.x;
uint l9_32=(l9_26.z*l9_29)+sc_RayTracingCasterOffsetPNTC.x;
vec3 l9_33;
if (sc_RayTracingCasterFormatPNTC.x==5u)
{
l9_33=((vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_30],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_30+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_30+2u])*l9_6)+(vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_31],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_31+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_31+2u])*l9_4))+(vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_32],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_32+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_32+2u])*l9_5);
}
else
{
vec3 l9_34;
if (sc_RayTracingCasterFormatPNTC.x==6u)
{
l9_34=((vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_30])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_30+1u])).x)*l9_6)+(vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_31])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_31+1u])).x)*l9_4))+(vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_32])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_32+1u])).x)*l9_5);
}
else
{
l9_34=vec3(1.0,0.0,0.0);
}
l9_33=l9_34;
}
l9_28=(sc_ModelMatrix*vec4(l9_33,1.0)).xyz;
}
vec3 l9_35;
if (sc_RayTracingCasterOffsetPNTC.y>0u)
{
vec3 l9_36;
if (l9_27)
{
l9_36=sc_RayTracingInterpolateAnimatedFloat3(l9_7,l9_26,3u);
}
else
{
uint l9_37=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_38=(l9_26.x*l9_37)+sc_RayTracingCasterOffsetPNTC.y;
uint l9_39=(l9_26.y*l9_37)+sc_RayTracingCasterOffsetPNTC.y;
uint l9_40=(l9_26.z*l9_37)+sc_RayTracingCasterOffsetPNTC.y;
vec3 l9_41;
if (sc_RayTracingCasterFormatPNTC.y==5u)
{
l9_41=((vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_38],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_38+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_38+2u])*l9_6)+(vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_39],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_39+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_39+2u])*l9_4))+(vec3(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_40],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_40+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_40+2u])*l9_5);
}
else
{
vec3 l9_42;
if (sc_RayTracingCasterFormatPNTC.y==6u)
{
l9_42=((vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_38])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_38+1u])).x)*l9_6)+(vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_39])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_39+1u])).x)*l9_4))+(vec3(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_40])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_40+1u])).x)*l9_5);
}
else
{
l9_42=vec3(1.0,0.0,0.0);
}
l9_41=l9_42;
}
l9_36=normalize(sc_NormalMatrix*l9_41);
}
l9_35=l9_36;
}
else
{
l9_35=vec3(1.0,0.0,0.0);
}
bool l9_43=!l9_27;
bool l9_44;
if (l9_43)
{
l9_44=sc_RayTracingCasterOffsetPNTC.z>0u;
}
else
{
l9_44=l9_43;
}
vec4 l9_45;
if (l9_44)
{
uint l9_46=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_47=(l9_26.x*l9_46)+sc_RayTracingCasterOffsetPNTC.z;
uint l9_48=(l9_26.y*l9_46)+sc_RayTracingCasterOffsetPNTC.z;
uint l9_49=(l9_26.z*l9_46)+sc_RayTracingCasterOffsetPNTC.z;
vec4 l9_50;
if (sc_RayTracingCasterFormatPNTC.z==5u)
{
l9_50=((vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47+3u])*l9_6)+(vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48+3u])*l9_4))+(vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49+3u])*l9_5);
}
else
{
vec4 l9_51;
if (sc_RayTracingCasterFormatPNTC.z==6u)
{
l9_51=((vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_47+1u])))*l9_6)+(vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_48+1u])))*l9_4))+(vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_49+1u])))*l9_5);
}
else
{
vec4 l9_52;
if (sc_RayTracingCasterFormatPNTC.z==2u)
{
l9_52=((sc_RayTracingFetchUnorm4(l9_47)*l9_6)+(sc_RayTracingFetchUnorm4(l9_48)*l9_4))+(sc_RayTracingFetchUnorm4(l9_49)*l9_5);
}
else
{
l9_52=vec4(1.0,0.0,0.0,0.0);
}
l9_51=l9_52;
}
l9_50=l9_51;
}
l9_45=vec4(normalize(sc_NormalMatrix*l9_50.xyz),l9_50.w);
}
else
{
l9_45=vec4(1.0,0.0,0.0,1.0);
}
vec4 l9_53;
if (sc_RayTracingCasterFormatPNTC.w>0u)
{
uint l9_54=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_55=(l9_26.x*l9_54)+sc_RayTracingCasterOffsetPNTC.w;
uint l9_56=(l9_26.y*l9_54)+sc_RayTracingCasterOffsetPNTC.w;
uint l9_57=(l9_26.z*l9_54)+sc_RayTracingCasterOffsetPNTC.w;
vec4 l9_58;
if (sc_RayTracingCasterFormatPNTC.w==5u)
{
l9_58=((vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55+3u])*l9_6)+(vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56+3u])*l9_4))+(vec4(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57+1u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57+2u],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57+3u])*l9_5);
}
else
{
vec4 l9_59;
if (sc_RayTracingCasterFormatPNTC.w==6u)
{
l9_59=((vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_55+1u])))*l9_6)+(vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_56+1u])))*l9_4))+(vec4(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57])),unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_57+1u])))*l9_5);
}
else
{
vec4 l9_60;
if (sc_RayTracingCasterFormatPNTC.w==2u)
{
l9_60=((sc_RayTracingFetchUnorm4(l9_55)*l9_6)+(sc_RayTracingFetchUnorm4(l9_56)*l9_4))+(sc_RayTracingFetchUnorm4(l9_57)*l9_5);
}
else
{
l9_60=vec4(1.0,0.0,0.0,0.0);
}
l9_59=l9_60;
}
l9_58=l9_59;
}
l9_53=l9_58;
}
else
{
l9_53=vec4(0.0);
}
uvec3 l9_61=l9_26%uvec3(2u);
vec2 l9_62=vec2(dot(l9_7,vec3(uvec3(1u)-l9_61)),0.0);
vec2 l9_63;
if (sc_RayTracingCasterFormatTexture.x>0u)
{
uint l9_64=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_65=(l9_26.x*l9_64)+sc_RayTracingCasterOffsetTexture.x;
uint l9_66=(l9_26.y*l9_64)+sc_RayTracingCasterOffsetTexture.x;
uint l9_67=(l9_26.z*l9_64)+sc_RayTracingCasterOffsetTexture.x;
vec2 l9_68;
if (sc_RayTracingCasterFormatTexture.x==5u)
{
l9_68=((vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_65],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_65+1u])*l9_6)+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_66],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_66+1u])*l9_4))+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_67],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_67+1u])*l9_5);
}
else
{
vec2 l9_69;
if (sc_RayTracingCasterFormatTexture.x==6u)
{
l9_69=((unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_65]))*l9_6)+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_66]))*l9_4))+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_67]))*l9_5);
}
else
{
l9_69=vec2(1.0,0.0);
}
l9_68=l9_69;
}
l9_63=l9_68;
}
else
{
l9_63=l9_62;
}
vec2 l9_70;
if (sc_RayTracingCasterFormatTexture.y>0u)
{
uint l9_71=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_72=(l9_26.x*l9_71)+sc_RayTracingCasterOffsetTexture.y;
uint l9_73=(l9_26.y*l9_71)+sc_RayTracingCasterOffsetTexture.y;
uint l9_74=(l9_26.z*l9_71)+sc_RayTracingCasterOffsetTexture.y;
vec2 l9_75;
if (sc_RayTracingCasterFormatTexture.y==5u)
{
l9_75=((vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_72],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_72+1u])*l9_6)+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_73],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_73+1u])*l9_4))+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_74],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_74+1u])*l9_5);
}
else
{
vec2 l9_76;
if (sc_RayTracingCasterFormatTexture.y==6u)
{
l9_76=((unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_72]))*l9_6)+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_73]))*l9_4))+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_74]))*l9_5);
}
else
{
l9_76=vec2(1.0,0.0);
}
l9_75=l9_76;
}
l9_70=l9_75;
}
else
{
l9_70=l9_62;
}
vec2 l9_77;
if (sc_RayTracingCasterFormatTexture.z>0u)
{
uint l9_78=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_79=(l9_26.x*l9_78)+sc_RayTracingCasterOffsetTexture.z;
uint l9_80=(l9_26.y*l9_78)+sc_RayTracingCasterOffsetTexture.z;
uint l9_81=(l9_26.z*l9_78)+sc_RayTracingCasterOffsetTexture.z;
vec2 l9_82;
if (sc_RayTracingCasterFormatTexture.z==5u)
{
l9_82=((vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_79],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_79+1u])*l9_6)+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_80],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_80+1u])*l9_4))+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_81],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_81+1u])*l9_5);
}
else
{
vec2 l9_83;
if (sc_RayTracingCasterFormatTexture.z==6u)
{
l9_83=((unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_79]))*l9_6)+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_80]))*l9_4))+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_81]))*l9_5);
}
else
{
l9_83=vec2(1.0,0.0);
}
l9_82=l9_83;
}
l9_77=l9_82;
}
else
{
l9_77=l9_62;
}
vec2 l9_84;
if (sc_RayTracingCasterFormatTexture.w>0u)
{
uint l9_85=sc_RayTracingCasterConfiguration.y>>16u;
uint l9_86=(l9_26.x*l9_85)+sc_RayTracingCasterOffsetTexture.w;
uint l9_87=(l9_26.y*l9_85)+sc_RayTracingCasterOffsetTexture.w;
uint l9_88=(l9_26.z*l9_85)+sc_RayTracingCasterOffsetTexture.w;
vec2 l9_89;
if (sc_RayTracingCasterFormatTexture.w==5u)
{
l9_89=((vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_86],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_86+1u])*l9_6)+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_87],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_87+1u])*l9_4))+(vec2(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_88],sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_88+1u])*l9_5);
}
else
{
vec2 l9_90;
if (sc_RayTracingCasterFormatTexture.w==6u)
{
l9_90=((unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_86]))*l9_6)+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_87]))*l9_4))+(unpackHalf2x16(floatBitsToUint(sc_RayTracingCasterVertexBuffer_obj.sc_RayTracingCasterVertices[l9_88]))*l9_5);
}
else
{
l9_90=vec2(1.0,0.0);
}
l9_89=l9_90;
}
l9_84=l9_89;
}
else
{
l9_84=l9_62;
}
return sc_RayTracingHitPayload(-normalize(vec3(l9_18.x,l9_18.y,l9_13.z)),l9_28,l9_35,l9_45,l9_53,l9_63,l9_70,l9_77,l9_84,l9_2);
}
void Node17_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_13_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_13_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_13_DROPLIST_ITEM==2)
{
Value2=Globals.gScreenCoord;
Result=Value2;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
void Node122_If_else(float Bool1,vec2 Value1,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (ENABLE_UV2_ANIMATION)
{
vec2 param_5;
Node17_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_5,Globals);
Value1=((param_5*uv2Scale)+uv2Offset)+(uv2Offset*(Globals.gTimeElapsed*Port_Speed_N022));
Result=Value1;
}
#else
{
vec2 param_12;
Node17_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_12,Globals);
Default=(param_12*uv2Scale)+uv2Offset;
Result=Default;
}
#endif
}
void Node79_If_else(float Bool1,vec2 Value1,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (ENABLE_UV2)
{
vec2 param_3;
Node122_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value1=param_3;
Result=Value1;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
void Node59_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Value3,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_49_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_49_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_49_DROPLIST_ITEM==2)
{
Value2=Globals.gScreenCoord;
Result=Value2;
}
#else
{
#if (NODE_49_DROPLIST_ITEM==3)
{
vec2 param_3;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value3=param_3;
Result=Value3;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
#endif
}
void Node64_If_else(float Bool1,vec2 Value1,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (ENABLE_UV3_ANIMATION)
{
vec2 param_6;
Node59_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_6,Globals);
Value1=((param_6*uv3Scale)+uv3Offset)+(uv3Offset*(Globals.gTimeElapsed*Port_Speed_N063));
Result=Value1;
}
#else
{
vec2 param_14;
Node59_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_14,Globals);
Default=(param_14*uv3Scale)+uv3Offset;
Result=Default;
}
#endif
}
void Node35_If_else(float Bool1,vec2 Value1,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (ENABLE_UV3)
{
vec2 param_3;
Node64_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value1=param_3;
Result=Value1;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
void Node388_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Value3,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_27_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_27_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_27_DROPLIST_ITEM==2)
{
vec2 param_3;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value2=param_3;
Result=Value2;
}
#else
{
#if (NODE_27_DROPLIST_ITEM==3)
{
vec2 param_8;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),param_8,Globals);
Value3=param_8;
Result=Value3;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
#endif
}
int baseTexGetStereoViewIndex()
{
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void sc_SoftwareWrapEarly(inout float uv,int softwareWrapMode)
{
if (softwareWrapMode==1)
{
uv=fract(uv);
}
else
{
if (softwareWrapMode==2)
{
float l9_0=fract(uv);
uv=mix(l9_0,1.0-l9_0,clamp(step(0.25,fract((uv-l9_0)*0.5)),0.0,1.0));
}
}
}
void sc_ClampUV(inout float value,float minValue,float maxValue,bool useClampToBorder,inout float clampToBorderFactor)
{
float l9_0=clamp(value,minValue,maxValue);
float l9_1=step(abs(value-l9_0),9.9999997e-06);
clampToBorderFactor*=(l9_1+((1.0-float(useClampToBorder))*(1.0-l9_1)));
value=l9_0;
}
vec2 sc_TransformUV(vec2 uv,bool useUvTransform,mat3 uvTransform)
{
if (useUvTransform)
{
uv=vec2((uvTransform*vec3(uv,1.0)).xy);
}
return uv;
}
void sc_SoftwareWrapLate(inout float uv,int softwareWrapMode,bool useClampToBorder,inout float clampToBorderFactor)
{
if ((softwareWrapMode==0)||(softwareWrapMode==3))
{
sc_ClampUV(uv,0.0,1.0,useClampToBorder,clampToBorderFactor);
}
}
vec3 sc_SamplingCoordsViewToGlobal(vec2 uv,int renderingLayout,int viewIndex)
{
vec3 l9_0;
if (renderingLayout==0)
{
l9_0=vec3(uv,0.0);
}
else
{
vec3 l9_1;
if (renderingLayout==1)
{
l9_1=vec3(uv.x,(uv.y*0.5)+(0.5-(float(viewIndex)*0.5)),0.0);
}
else
{
l9_1=vec3(uv,float(viewIndex));
}
l9_0=l9_1;
}
return l9_0;
}
void Node369_If_else(float Bool1,vec4 Value1,vec4 Default,out vec4 Result,ssGlobals Globals)
{
#if (ENABLE_BASE_TEX)
{
vec2 param_6;
Node388_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_6,Globals);
vec2 l9_0=param_6;
vec4 l9_1;
#if (baseTexLayout==2)
{
bool l9_2=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_3=l9_0.x;
sc_SoftwareWrapEarly(l9_3,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_4=l9_3;
float l9_5=l9_0.y;
sc_SoftwareWrapEarly(l9_5,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_6=l9_5;
vec2 l9_7;
float l9_8;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_9;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_9=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_9=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_10=l9_4;
float l9_11=1.0;
sc_ClampUV(l9_10,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_9,l9_11);
float l9_12=l9_10;
float l9_13=l9_11;
bool l9_14;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_14=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_14=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_15=l9_6;
float l9_16=l9_13;
sc_ClampUV(l9_15,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_14,l9_16);
l9_8=l9_16;
l9_7=vec2(l9_12,l9_15);
}
#else
{
l9_8=1.0;
l9_7=vec2(l9_4,l9_6);
}
#endif
vec2 l9_17=sc_TransformUV(l9_7,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform);
float l9_18=l9_17.x;
float l9_19=l9_8;
sc_SoftwareWrapLate(l9_18,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_2,l9_19);
float l9_20=l9_17.y;
float l9_21=l9_19;
sc_SoftwareWrapLate(l9_20,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_2,l9_21);
float l9_22=l9_21;
vec3 l9_23=sc_SamplingCoordsViewToGlobal(vec2(l9_18,l9_20),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_24=texture(baseTexArrSC,l9_23,0.0);
vec4 l9_25;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_25=mix(baseTexBorderColor,l9_24,vec4(l9_22));
}
#else
{
l9_25=l9_24;
}
#endif
l9_1=l9_25;
}
#else
{
bool l9_26=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_27=l9_0.x;
sc_SoftwareWrapEarly(l9_27,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_28=l9_27;
float l9_29=l9_0.y;
sc_SoftwareWrapEarly(l9_29,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_30=l9_29;
vec2 l9_31;
float l9_32;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_33;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_33=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_33=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_34=l9_28;
float l9_35=1.0;
sc_ClampUV(l9_34,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_33,l9_35);
float l9_36=l9_34;
float l9_37=l9_35;
bool l9_38;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_38=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_38=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_39=l9_30;
float l9_40=l9_37;
sc_ClampUV(l9_39,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_38,l9_40);
l9_32=l9_40;
l9_31=vec2(l9_36,l9_39);
}
#else
{
l9_32=1.0;
l9_31=vec2(l9_28,l9_30);
}
#endif
vec2 l9_41=sc_TransformUV(l9_31,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform);
float l9_42=l9_41.x;
float l9_43=l9_32;
sc_SoftwareWrapLate(l9_42,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_26,l9_43);
float l9_44=l9_41.y;
float l9_45=l9_43;
sc_SoftwareWrapLate(l9_44,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_26,l9_45);
float l9_46=l9_45;
vec3 l9_47=sc_SamplingCoordsViewToGlobal(vec2(l9_42,l9_44),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_48=texture(baseTex,l9_47.xy,0.0);
vec4 l9_49;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_49=mix(baseTexBorderColor,l9_48,vec4(l9_46));
}
#else
{
l9_49=l9_48;
}
#endif
l9_1=l9_49;
}
#endif
Value1=l9_1;
Result=Value1;
}
#else
{
Result=Default;
}
#endif
}
void Node80_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
#if (ENABLE_RECOLOR)
{
vec4 param_3;
Node369_If_else(0.0,vec4(0.0),Port_Default_N369,param_3,Globals);
vec4 l9_0=baseColor*param_3;
Value1=((recolorRed*vec3(l9_0.x))+(recolorGreen*vec3(l9_0.y)))+(recolorBlue*vec3(l9_0.z));
Result=Value1;
}
#else
{
vec4 param_8;
Node369_If_else(0.0,vec4(0.0),Port_Default_N369,param_8,Globals);
Default=(baseColor*param_8).xyz;
Result=Default;
}
#endif
}
void Node128_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Value3,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_76_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_76_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_76_DROPLIST_ITEM==2)
{
vec2 param_3;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value2=param_3;
Result=Value2;
}
#else
{
#if (NODE_76_DROPLIST_ITEM==3)
{
vec2 param_8;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),param_8,Globals);
Value3=param_8;
Result=Value3;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
#endif
}
int emissiveTexGetStereoViewIndex()
{
int l9_0;
#if (emissiveTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void Node132_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
#if (ENABLE_EMISSIVE)
{
vec2 param_6;
Node128_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_6,Globals);
vec2 l9_0=param_6;
vec4 l9_1;
#if (emissiveTexLayout==2)
{
bool l9_2=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_emissiveTex)!=0));
float l9_3=l9_0.x;
sc_SoftwareWrapEarly(l9_3,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x);
float l9_4=l9_3;
float l9_5=l9_0.y;
sc_SoftwareWrapEarly(l9_5,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y);
float l9_6=l9_5;
vec2 l9_7;
float l9_8;
#if (SC_USE_UV_MIN_MAX_emissiveTex)
{
bool l9_9;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_9=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x==3;
}
#else
{
l9_9=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0);
}
#endif
float l9_10=l9_4;
float l9_11=1.0;
sc_ClampUV(l9_10,emissiveTexUvMinMax.x,emissiveTexUvMinMax.z,l9_9,l9_11);
float l9_12=l9_10;
float l9_13=l9_11;
bool l9_14;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_14=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y==3;
}
#else
{
l9_14=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0);
}
#endif
float l9_15=l9_6;
float l9_16=l9_13;
sc_ClampUV(l9_15,emissiveTexUvMinMax.y,emissiveTexUvMinMax.w,l9_14,l9_16);
l9_8=l9_16;
l9_7=vec2(l9_12,l9_15);
}
#else
{
l9_8=1.0;
l9_7=vec2(l9_4,l9_6);
}
#endif
vec2 l9_17=sc_TransformUV(l9_7,(int(SC_USE_UV_TRANSFORM_emissiveTex)!=0),emissiveTexTransform);
float l9_18=l9_17.x;
float l9_19=l9_8;
sc_SoftwareWrapLate(l9_18,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x,l9_2,l9_19);
float l9_20=l9_17.y;
float l9_21=l9_19;
sc_SoftwareWrapLate(l9_20,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y,l9_2,l9_21);
float l9_22=l9_21;
vec3 l9_23=sc_SamplingCoordsViewToGlobal(vec2(l9_18,l9_20),emissiveTexLayout,emissiveTexGetStereoViewIndex());
vec4 l9_24=texture(emissiveTexArrSC,l9_23,0.0);
vec4 l9_25;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_25=mix(emissiveTexBorderColor,l9_24,vec4(l9_22));
}
#else
{
l9_25=l9_24;
}
#endif
l9_1=l9_25;
}
#else
{
bool l9_26=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_emissiveTex)!=0));
float l9_27=l9_0.x;
sc_SoftwareWrapEarly(l9_27,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x);
float l9_28=l9_27;
float l9_29=l9_0.y;
sc_SoftwareWrapEarly(l9_29,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y);
float l9_30=l9_29;
vec2 l9_31;
float l9_32;
#if (SC_USE_UV_MIN_MAX_emissiveTex)
{
bool l9_33;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_33=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x==3;
}
#else
{
l9_33=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0);
}
#endif
float l9_34=l9_28;
float l9_35=1.0;
sc_ClampUV(l9_34,emissiveTexUvMinMax.x,emissiveTexUvMinMax.z,l9_33,l9_35);
float l9_36=l9_34;
float l9_37=l9_35;
bool l9_38;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_38=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y==3;
}
#else
{
l9_38=(int(SC_USE_CLAMP_TO_BORDER_emissiveTex)!=0);
}
#endif
float l9_39=l9_30;
float l9_40=l9_37;
sc_ClampUV(l9_39,emissiveTexUvMinMax.y,emissiveTexUvMinMax.w,l9_38,l9_40);
l9_32=l9_40;
l9_31=vec2(l9_36,l9_39);
}
#else
{
l9_32=1.0;
l9_31=vec2(l9_28,l9_30);
}
#endif
vec2 l9_41=sc_TransformUV(l9_31,(int(SC_USE_UV_TRANSFORM_emissiveTex)!=0),emissiveTexTransform);
float l9_42=l9_41.x;
float l9_43=l9_32;
sc_SoftwareWrapLate(l9_42,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).x,l9_26,l9_43);
float l9_44=l9_41.y;
float l9_45=l9_43;
sc_SoftwareWrapLate(l9_44,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTex,SC_SOFTWARE_WRAP_MODE_V_emissiveTex).y,l9_26,l9_45);
float l9_46=l9_45;
vec3 l9_47=sc_SamplingCoordsViewToGlobal(vec2(l9_42,l9_44),emissiveTexLayout,emissiveTexGetStereoViewIndex());
vec4 l9_48=texture(emissiveTex,l9_47.xy,0.0);
vec4 l9_49;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTex)
{
l9_49=mix(emissiveTexBorderColor,l9_48,vec4(l9_46));
}
#else
{
l9_49=l9_48;
}
#endif
l9_1=l9_49;
}
#endif
Value1=l9_1.xyz;
Result=Value1;
}
#else
{
Result=Default;
}
#endif
}
vec3 ssSRGB_to_Linear(vec3 value)
{
vec3 l9_0;
#if (SC_DEVICE_CLASS>=2)
{
l9_0=vec3(pow(value.x,2.2),pow(value.y,2.2),pow(value.z,2.2));
}
#else
{
l9_0=value*value;
}
#endif
return l9_0;
}
void Node346_Normalize(vec3 Input0,out vec3 Output,ssGlobals Globals)
{
vec3 l9_0=Input0;
vec3 l9_1=Input0;
float l9_2=dot(l9_0,l9_1);
float l9_3;
if (l9_2>0.0)
{
l9_3=1.0/sqrt(l9_2);
}
else
{
l9_3=0.0;
}
Output=Input0*l9_3;
}
void Node208_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Value3,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_181_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_181_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_181_DROPLIST_ITEM==2)
{
vec2 param_3;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value2=param_3;
Result=Value2;
}
#else
{
#if (NODE_181_DROPLIST_ITEM==3)
{
vec2 param_8;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),param_8,Globals);
Value3=param_8;
Result=Value3;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
#endif
}
int normalTexGetStereoViewIndex()
{
int l9_0;
#if (normalTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void Node126_Texture_2D_Sample(vec2 UVCoord,out vec4 Color,ssGlobals Globals)
{
vec4 l9_0;
#if (normalTexLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_normalTex)!=0));
float l9_2=UVCoord.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x);
float l9_3=l9_2;
float l9_4=UVCoord.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_normalTex)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,normalTexUvMinMax.x,normalTexUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,normalTexUvMinMax.y,normalTexUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_normalTex)!=0),normalTexTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),normalTexLayout,normalTexGetStereoViewIndex());
vec4 l9_23=texture(normalTexArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_24=mix(normalTexBorderColor,l9_23,vec4(l9_21));
}
#else
{
l9_24=l9_23;
}
#endif
l9_0=l9_24;
}
#else
{
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_normalTex)!=0));
float l9_26=UVCoord.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x);
float l9_27=l9_26;
float l9_28=UVCoord.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_normalTex)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,normalTexUvMinMax.x,normalTexUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_normalTex)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,normalTexUvMinMax.y,normalTexUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_normalTex)!=0),normalTexTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTex,SC_SOFTWARE_WRAP_MODE_V_normalTex).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),normalTexLayout,normalTexGetStereoViewIndex());
vec4 l9_47=texture(normalTex,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_normalTex)
{
l9_48=mix(normalTexBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
Color=l9_0;
vec3 l9_49=(Color.xyz*1.9921875)-vec3(1.0);
Color=vec4(l9_49.x,l9_49.y,l9_49.z,Color.w);
}
void Node111_Switch(float Switch,vec2 Value0,vec2 Value1,vec2 Value2,vec2 Value3,vec2 Default,out vec2 Result,ssGlobals Globals)
{
#if (NODE_184_DROPLIST_ITEM==0)
{
Value0=Globals.Surface_UVCoord0;
Result=Value0;
}
#else
{
#if (NODE_184_DROPLIST_ITEM==1)
{
Value1=Globals.Surface_UVCoord1;
Result=Value1;
}
#else
{
#if (NODE_184_DROPLIST_ITEM==2)
{
vec2 param_3;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),param_3,Globals);
Value2=param_3;
Result=Value2;
}
#else
{
#if (NODE_184_DROPLIST_ITEM==3)
{
vec2 param_8;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),param_8,Globals);
Value3=param_8;
Result=Value3;
}
#else
{
Default=Globals.Surface_UVCoord0;
Result=Default;
}
#endif
}
#endif
}
#endif
}
#endif
}
int detailNormalTexGetStereoViewIndex()
{
int l9_0;
#if (detailNormalTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void Node138_Texture_2D_Sample(vec2 UVCoord,out vec4 Color,ssGlobals Globals)
{
vec4 l9_0;
#if (detailNormalTexLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_detailNormalTex)!=0));
float l9_2=UVCoord.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x);
float l9_3=l9_2;
float l9_4=UVCoord.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_detailNormalTex)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,detailNormalTexUvMinMax.x,detailNormalTexUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,detailNormalTexUvMinMax.y,detailNormalTexUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_detailNormalTex)!=0),detailNormalTexTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),detailNormalTexLayout,detailNormalTexGetStereoViewIndex());
vec4 l9_23=texture(detailNormalTexArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_24=mix(detailNormalTexBorderColor,l9_23,vec4(l9_21));
}
#else
{
l9_24=l9_23;
}
#endif
l9_0=l9_24;
}
#else
{
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_detailNormalTex)!=0));
float l9_26=UVCoord.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x);
float l9_27=l9_26;
float l9_28=UVCoord.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_detailNormalTex)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,detailNormalTexUvMinMax.x,detailNormalTexUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_detailNormalTex)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,detailNormalTexUvMinMax.y,detailNormalTexUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_detailNormalTex)!=0),detailNormalTexTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_detailNormalTex,SC_SOFTWARE_WRAP_MODE_V_detailNormalTex).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),detailNormalTexLayout,detailNormalTexGetStereoViewIndex());
vec4 l9_47=texture(detailNormalTex,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_detailNormalTex)
{
l9_48=mix(detailNormalTexBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
Color=l9_0;
vec3 l9_49=(Color.xyz*1.9921875)-vec3(1.0);
Color=vec4(l9_49.x,l9_49.y,l9_49.z,Color.w);
}
void Node113_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
#if (ENABLE_DETAIL_NORMAL)
{
vec2 param_6;
Node111_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_6,Globals);
vec4 param_9;
Node138_Texture_2D_Sample(param_6,param_9,Globals);
Value1=param_9.xyz;
Result=Value1;
}
#else
{
Result=Default;
}
#endif
}
vec3 ngs_CombineNormals(vec3 Normal1,float Strength1,vec3 Normal2,float Strength2)
{
vec3 l9_0=mix(vec3(0.0,0.0,1.0),Normal1,vec3(Strength1))+vec3(0.0,0.0,1.0);
vec3 l9_1=mix(vec3(0.0,0.0,1.0),Normal2,vec3(Strength2))*vec3(-1.0,-1.0,1.0);
return normalize((l9_0*dot(l9_0,l9_1))-(l9_1*l9_0.z));
}
void Node345_Normalize(vec3 Input0,out vec3 Output,ssGlobals Globals)
{
vec3 l9_0=Input0;
vec3 l9_1=Input0;
float l9_2=dot(l9_0,l9_1);
float l9_3;
if (l9_2>0.0)
{
l9_3=1.0/sqrt(l9_2);
}
else
{
l9_3=0.0;
}
Output=Input0*l9_3;
}
void Node337_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
#if (ENABLE_NORMALMAP)
{
vec2 param_6;
Node208_Switch(0.0,vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),vec2(0.0),param_6,Globals);
vec4 param_9;
Node126_Texture_2D_Sample(param_6,param_9,Globals);
vec3 param_14;
Node113_If_else(0.0,vec3(0.0),Port_Default_N113,param_14,Globals);
vec3 param_17;
Node345_Normalize(mat3(Globals.VertexTangent_WorldSpace,Globals.VertexBinormal_WorldSpace,Globals.VertexNormal_WorldSpace)*ngs_CombineNormals(param_9.xyz,Port_Strength1_N200,param_14,Port_Strength2_N200),param_17,Globals);
Value1=param_17;
Result=Value1;
}
#else
{
vec3 param_20;
Node346_Normalize(Globals.VertexNormal_WorldSpace,param_20,Globals);
Default=param_20;
Result=Default;
}
#endif
}
int reflectionTexGetStereoViewIndex()
{
int l9_0;
#if (reflectionTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
int reflectionModulationTexGetStereoViewIndex()
{
int l9_0;
#if (reflectionModulationTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
int rimColorTexGetStereoViewIndex()
{
int l9_0;
#if (rimColorTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
int opacityTexGetStereoViewIndex()
{
int l9_0;
#if (opacityTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void sc_writeFragData0(vec4 col)
{
#if (sc_ShaderCacheConstant!=0)
{
col.x+=(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
}
#endif
sc_FragData0=col;
}
int sc_ScreenTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_ScreenTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
vec4 sc_readFragData0()
{
#if sc_FramebufferFetch
#ifdef GL_EXT_shader_framebuffer_fetch
return sc_FragData0;
#elif defined(GL_ARM_shader_framebuffer_fetch)
return gl_LastFragColorARM;
#endif
#else
return vec4(0.0);
#endif
}
int intensityTextureGetStereoViewIndex()
{
int l9_0;
#if (intensityTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
float transformSingleColor(float original,float intMap,float target)
{
#if ((BLEND_MODE_REALISTIC||BLEND_MODE_FORGRAY)||BLEND_MODE_NOTBRIGHT)
{
return original/pow(1.0-target,intMap);
}
#else
{
#if (BLEND_MODE_DIVISION)
{
return original/(1.0-target);
}
#else
{
#if (BLEND_MODE_BRIGHT)
{
return original/pow(1.0-target,2.0-(2.0*original));
}
#endif
}
#endif
}
#endif
return 0.0;
}
vec3 RGBtoHCV(vec3 rgb)
{
vec4 l9_0;
if (rgb.y<rgb.z)
{
l9_0=vec4(rgb.zy,-1.0,0.66666669);
}
else
{
l9_0=vec4(rgb.yz,0.0,-0.33333334);
}
vec4 l9_1;
if (rgb.x<l9_0.x)
{
l9_1=vec4(l9_0.xyw,rgb.x);
}
else
{
l9_1=vec4(rgb.x,l9_0.yzx);
}
float l9_2=l9_1.x-min(l9_1.w,l9_1.y);
return vec3(abs(((l9_1.w-l9_1.y)/((6.0*l9_2)+1e-07))+l9_1.z),l9_2,l9_1.x);
}
vec3 RGBToHSL(vec3 rgb)
{
vec3 l9_0=RGBtoHCV(rgb);
float l9_1=l9_0.y;
float l9_2=l9_0.z-(l9_1*0.5);
return vec3(l9_0.x,l9_1/((1.0-abs((2.0*l9_2)-1.0))+1e-07),l9_2);
}
vec3 HUEtoRGB(float hue)
{
return clamp(vec3(abs((6.0*hue)-3.0)-1.0,2.0-abs((6.0*hue)-2.0),2.0-abs((6.0*hue)-4.0)),vec3(0.0),vec3(1.0));
}
vec3 HSLToRGB(vec3 hsl)
{
return ((HUEtoRGB(hsl.x)-vec3(0.5))*((1.0-abs((2.0*hsl.z)-1.0))*hsl.y))+vec3(hsl.z);
}
vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap)
{
#if (BLEND_MODE_INTENSE)
{
return mix(original,HSLToRGB(vec3(target.x,target.y,RGBToHSL(original).z)),vec3(weight));
}
#else
{
return mix(original,clamp(vec3(transformSingleColor(yValue,intMap,target.x),transformSingleColor(yValue,intMap,target.y),transformSingleColor(yValue,intMap,target.z)),vec3(0.0),vec3(1.0)),vec3(weight));
}
#endif
}
vec3 definedBlend(vec3 a,vec3 b)
{
#if (BLEND_MODE_LIGHTEN)
{
return max(a,b);
}
#else
{
#if (BLEND_MODE_DARKEN)
{
return min(a,b);
}
#else
{
#if (BLEND_MODE_DIVIDE)
{
return b/a;
}
#else
{
#if (BLEND_MODE_AVERAGE)
{
return (a+b)*0.5;
}
#else
{
#if (BLEND_MODE_SUBTRACT)
{
return max((a+b)-vec3(1.0),vec3(0.0));
}
#else
{
#if (BLEND_MODE_DIFFERENCE)
{
return abs(a-b);
}
#else
{
#if (BLEND_MODE_NEGATION)
{
return vec3(1.0)-abs((vec3(1.0)-a)-b);
}
#else
{
#if (BLEND_MODE_EXCLUSION)
{
return (a+b)-((a*2.0)*b);
}
#else
{
#if (BLEND_MODE_OVERLAY)
{
float l9_0;
if (a.x<0.5)
{
l9_0=(2.0*a.x)*b.x;
}
else
{
l9_0=1.0-((2.0*(1.0-a.x))*(1.0-b.x));
}
float l9_1;
if (a.y<0.5)
{
l9_1=(2.0*a.y)*b.y;
}
else
{
l9_1=1.0-((2.0*(1.0-a.y))*(1.0-b.y));
}
float l9_2;
if (a.z<0.5)
{
l9_2=(2.0*a.z)*b.z;
}
else
{
l9_2=1.0-((2.0*(1.0-a.z))*(1.0-b.z));
}
return vec3(l9_0,l9_1,l9_2);
}
#else
{
#if (BLEND_MODE_SOFT_LIGHT)
{
return (((vec3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
}
#else
{
#if (BLEND_MODE_HARD_LIGHT)
{
float l9_3;
if (b.x<0.5)
{
l9_3=(2.0*b.x)*a.x;
}
else
{
l9_3=1.0-((2.0*(1.0-b.x))*(1.0-a.x));
}
float l9_4;
if (b.y<0.5)
{
l9_4=(2.0*b.y)*a.y;
}
else
{
l9_4=1.0-((2.0*(1.0-b.y))*(1.0-a.y));
}
float l9_5;
if (b.z<0.5)
{
l9_5=(2.0*b.z)*a.z;
}
else
{
l9_5=1.0-((2.0*(1.0-b.z))*(1.0-a.z));
}
return vec3(l9_3,l9_4,l9_5);
}
#else
{
#if (BLEND_MODE_COLOR_DODGE)
{
float l9_6;
if (b.x==1.0)
{
l9_6=b.x;
}
else
{
l9_6=min(a.x/(1.0-b.x),1.0);
}
float l9_7;
if (b.y==1.0)
{
l9_7=b.y;
}
else
{
l9_7=min(a.y/(1.0-b.y),1.0);
}
float l9_8;
if (b.z==1.0)
{
l9_8=b.z;
}
else
{
l9_8=min(a.z/(1.0-b.z),1.0);
}
return vec3(l9_6,l9_7,l9_8);
}
#else
{
#if (BLEND_MODE_COLOR_BURN)
{
float l9_9;
if (b.x==0.0)
{
l9_9=b.x;
}
else
{
l9_9=max(1.0-((1.0-a.x)/b.x),0.0);
}
float l9_10;
if (b.y==0.0)
{
l9_10=b.y;
}
else
{
l9_10=max(1.0-((1.0-a.y)/b.y),0.0);
}
float l9_11;
if (b.z==0.0)
{
l9_11=b.z;
}
else
{
l9_11=max(1.0-((1.0-a.z)/b.z),0.0);
}
return vec3(l9_9,l9_10,l9_11);
}
#else
{
#if (BLEND_MODE_LINEAR_LIGHT)
{
float l9_12;
if (b.x<0.5)
{
l9_12=max((a.x+(2.0*b.x))-1.0,0.0);
}
else
{
l9_12=min(a.x+(2.0*(b.x-0.5)),1.0);
}
float l9_13;
if (b.y<0.5)
{
l9_13=max((a.y+(2.0*b.y))-1.0,0.0);
}
else
{
l9_13=min(a.y+(2.0*(b.y-0.5)),1.0);
}
float l9_14;
if (b.z<0.5)
{
l9_14=max((a.z+(2.0*b.z))-1.0,0.0);
}
else
{
l9_14=min(a.z+(2.0*(b.z-0.5)),1.0);
}
return vec3(l9_12,l9_13,l9_14);
}
#else
{
#if (BLEND_MODE_VIVID_LIGHT)
{
float l9_15;
if (b.x<0.5)
{
float l9_16;
if ((2.0*b.x)==0.0)
{
l9_16=2.0*b.x;
}
else
{
l9_16=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_15=l9_16;
}
else
{
float l9_17;
if ((2.0*(b.x-0.5))==1.0)
{
l9_17=2.0*(b.x-0.5);
}
else
{
l9_17=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_15=l9_17;
}
float l9_18;
if (b.y<0.5)
{
float l9_19;
if ((2.0*b.y)==0.0)
{
l9_19=2.0*b.y;
}
else
{
l9_19=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_18=l9_19;
}
else
{
float l9_20;
if ((2.0*(b.y-0.5))==1.0)
{
l9_20=2.0*(b.y-0.5);
}
else
{
l9_20=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_18=l9_20;
}
float l9_21;
if (b.z<0.5)
{
float l9_22;
if ((2.0*b.z)==0.0)
{
l9_22=2.0*b.z;
}
else
{
l9_22=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_21=l9_22;
}
else
{
float l9_23;
if ((2.0*(b.z-0.5))==1.0)
{
l9_23=2.0*(b.z-0.5);
}
else
{
l9_23=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_21=l9_23;
}
return vec3(l9_15,l9_18,l9_21);
}
#else
{
#if (BLEND_MODE_PIN_LIGHT)
{
float l9_24;
if (b.x<0.5)
{
l9_24=min(a.x,2.0*b.x);
}
else
{
l9_24=max(a.x,2.0*(b.x-0.5));
}
float l9_25;
if (b.y<0.5)
{
l9_25=min(a.y,2.0*b.y);
}
else
{
l9_25=max(a.y,2.0*(b.y-0.5));
}
float l9_26;
if (b.z<0.5)
{
l9_26=min(a.z,2.0*b.z);
}
else
{
l9_26=max(a.z,2.0*(b.z-0.5));
}
return vec3(l9_24,l9_25,l9_26);
}
#else
{
#if (BLEND_MODE_HARD_MIX)
{
float l9_27;
if (b.x<0.5)
{
float l9_28;
if ((2.0*b.x)==0.0)
{
l9_28=2.0*b.x;
}
else
{
l9_28=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_27=l9_28;
}
else
{
float l9_29;
if ((2.0*(b.x-0.5))==1.0)
{
l9_29=2.0*(b.x-0.5);
}
else
{
l9_29=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_27=l9_29;
}
bool l9_30=l9_27<0.5;
float l9_31;
if (b.y<0.5)
{
float l9_32;
if ((2.0*b.y)==0.0)
{
l9_32=2.0*b.y;
}
else
{
l9_32=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_31=l9_32;
}
else
{
float l9_33;
if ((2.0*(b.y-0.5))==1.0)
{
l9_33=2.0*(b.y-0.5);
}
else
{
l9_33=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_31=l9_33;
}
bool l9_34=l9_31<0.5;
float l9_35;
if (b.z<0.5)
{
float l9_36;
if ((2.0*b.z)==0.0)
{
l9_36=2.0*b.z;
}
else
{
l9_36=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_35=l9_36;
}
else
{
float l9_37;
if ((2.0*(b.z-0.5))==1.0)
{
l9_37=2.0*(b.z-0.5);
}
else
{
l9_37=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_35=l9_37;
}
return vec3(l9_30 ? 0.0 : 1.0,l9_34 ? 0.0 : 1.0,(l9_35<0.5) ? 0.0 : 1.0);
}
#else
{
#if (BLEND_MODE_HARD_REFLECT)
{
float l9_38;
if (b.x==1.0)
{
l9_38=b.x;
}
else
{
l9_38=min((a.x*a.x)/(1.0-b.x),1.0);
}
float l9_39;
if (b.y==1.0)
{
l9_39=b.y;
}
else
{
l9_39=min((a.y*a.y)/(1.0-b.y),1.0);
}
float l9_40;
if (b.z==1.0)
{
l9_40=b.z;
}
else
{
l9_40=min((a.z*a.z)/(1.0-b.z),1.0);
}
return vec3(l9_38,l9_39,l9_40);
}
#else
{
#if (BLEND_MODE_HARD_GLOW)
{
float l9_41;
if (a.x==1.0)
{
l9_41=a.x;
}
else
{
l9_41=min((b.x*b.x)/(1.0-a.x),1.0);
}
float l9_42;
if (a.y==1.0)
{
l9_42=a.y;
}
else
{
l9_42=min((b.y*b.y)/(1.0-a.y),1.0);
}
float l9_43;
if (a.z==1.0)
{
l9_43=a.z;
}
else
{
l9_43=min((b.z*b.z)/(1.0-a.z),1.0);
}
return vec3(l9_41,l9_42,l9_43);
}
#else
{
#if (BLEND_MODE_HARD_PHOENIX)
{
return (min(a,b)-max(a,b))+vec3(1.0);
}
#else
{
#if (BLEND_MODE_HUE)
{
return HSLToRGB(vec3(RGBToHSL(b).x,RGBToHSL(a).yz));
}
#else
{
#if (BLEND_MODE_SATURATION)
{
vec3 l9_44=RGBToHSL(a);
return HSLToRGB(vec3(l9_44.x,RGBToHSL(b).y,l9_44.z));
}
#else
{
#if (BLEND_MODE_COLOR)
{
return HSLToRGB(vec3(RGBToHSL(b).xy,RGBToHSL(a).z));
}
#else
{
#if (BLEND_MODE_LUMINOSITY)
{
return HSLToRGB(vec3(RGBToHSL(a).xy,RGBToHSL(b).z));
}
#else
{
vec3 l9_45=a;
vec3 l9_46=b;
float l9_47=((0.29899999*l9_45.x)+(0.58700001*l9_45.y))+(0.114*l9_45.z);
float l9_48=pow(l9_47,1.0/correctedIntensity);
vec4 l9_49;
#if (intensityTextureLayout==2)
{
bool l9_50=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0));
float l9_51=l9_48;
sc_SoftwareWrapEarly(l9_51,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x);
float l9_52=l9_51;
float l9_53=0.5;
sc_SoftwareWrapEarly(l9_53,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y);
float l9_54=l9_53;
vec2 l9_55;
float l9_56;
#if (SC_USE_UV_MIN_MAX_intensityTexture)
{
bool l9_57;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_57=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x==3;
}
#else
{
l9_57=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_58=l9_52;
float l9_59=1.0;
sc_ClampUV(l9_58,intensityTextureUvMinMax.x,intensityTextureUvMinMax.z,l9_57,l9_59);
float l9_60=l9_58;
float l9_61=l9_59;
bool l9_62;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_62=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y==3;
}
#else
{
l9_62=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_63=l9_54;
float l9_64=l9_61;
sc_ClampUV(l9_63,intensityTextureUvMinMax.y,intensityTextureUvMinMax.w,l9_62,l9_64);
l9_56=l9_64;
l9_55=vec2(l9_60,l9_63);
}
#else
{
l9_56=1.0;
l9_55=vec2(l9_52,l9_54);
}
#endif
vec2 l9_65=sc_TransformUV(l9_55,(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0),intensityTextureTransform);
float l9_66=l9_65.x;
float l9_67=l9_56;
sc_SoftwareWrapLate(l9_66,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x,l9_50,l9_67);
float l9_68=l9_65.y;
float l9_69=l9_67;
sc_SoftwareWrapLate(l9_68,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y,l9_50,l9_69);
float l9_70=l9_69;
vec3 l9_71=sc_SamplingCoordsViewToGlobal(vec2(l9_66,l9_68),intensityTextureLayout,intensityTextureGetStereoViewIndex());
vec4 l9_72=texture(intensityTextureArrSC,l9_71,0.0);
vec4 l9_73;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_73=mix(intensityTextureBorderColor,l9_72,vec4(l9_70));
}
#else
{
l9_73=l9_72;
}
#endif
l9_49=l9_73;
}
#else
{
bool l9_74=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0));
float l9_75=l9_48;
sc_SoftwareWrapEarly(l9_75,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x);
float l9_76=l9_75;
float l9_77=0.5;
sc_SoftwareWrapEarly(l9_77,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y);
float l9_78=l9_77;
vec2 l9_79;
float l9_80;
#if (SC_USE_UV_MIN_MAX_intensityTexture)
{
bool l9_81;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_81=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x==3;
}
#else
{
l9_81=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_82=l9_76;
float l9_83=1.0;
sc_ClampUV(l9_82,intensityTextureUvMinMax.x,intensityTextureUvMinMax.z,l9_81,l9_83);
float l9_84=l9_82;
float l9_85=l9_83;
bool l9_86;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_86=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y==3;
}
#else
{
l9_86=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_87=l9_78;
float l9_88=l9_85;
sc_ClampUV(l9_87,intensityTextureUvMinMax.y,intensityTextureUvMinMax.w,l9_86,l9_88);
l9_80=l9_88;
l9_79=vec2(l9_84,l9_87);
}
#else
{
l9_80=1.0;
l9_79=vec2(l9_76,l9_78);
}
#endif
vec2 l9_89=sc_TransformUV(l9_79,(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0),intensityTextureTransform);
float l9_90=l9_89.x;
float l9_91=l9_80;
sc_SoftwareWrapLate(l9_90,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x,l9_74,l9_91);
float l9_92=l9_89.y;
float l9_93=l9_91;
sc_SoftwareWrapLate(l9_92,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y,l9_74,l9_93);
float l9_94=l9_93;
vec3 l9_95=sc_SamplingCoordsViewToGlobal(vec2(l9_90,l9_92),intensityTextureLayout,intensityTextureGetStereoViewIndex());
vec4 l9_96=texture(intensityTexture,l9_95.xy,0.0);
vec4 l9_97;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_97=mix(intensityTextureBorderColor,l9_96,vec4(l9_94));
}
#else
{
l9_97=l9_96;
}
#endif
l9_49=l9_97;
}
#endif
float l9_98=((((l9_49.x*256.0)+l9_49.y)+(l9_49.z/256.0))/257.00391)*16.0;
float l9_99;
#if (BLEND_MODE_FORGRAY)
{
l9_99=max(l9_98,1.0);
}
#else
{
l9_99=l9_98;
}
#endif
float l9_100;
#if (BLEND_MODE_NOTBRIGHT)
{
l9_100=min(l9_99,1.0);
}
#else
{
l9_100=l9_99;
}
#endif
return transformColor(l9_47,l9_45,l9_46,1.0,l9_100);
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
vec4 sc_OutputMotionVectorIfNeeded(vec4 finalColor)
{
#if (sc_MotionVectorsPass)
{
float l9_0=floor(((varPosAndMotion.w*5.0)+0.5)*65535.0);
float l9_1=floor(l9_0*0.00390625);
float l9_2=floor(((varNormalAndMotion.w*5.0)+0.5)*65535.0);
float l9_3=floor(l9_2*0.00390625);
return vec4(l9_1/255.0,(l9_0-(l9_1*256.0))/255.0,l9_3/255.0,(l9_2-(l9_3*256.0))/255.0);
}
#else
{
return finalColor;
}
#endif
}
float getFrontLayerZTestEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 5e-07;
}
#else
{
return 5.0000001e-08;
}
#endif
}
void unpackValues(float channel,int passIndex,inout int values[8])
{
#if (sc_OITCompositingPass)
{
channel=floor((channel*255.0)+0.5);
int l9_0=((passIndex+1)*4)-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_0>=(passIndex*4))
{
values[l9_0]=(values[l9_0]*4)+int(floor(mod(channel,4.0)));
channel=floor(channel/4.0);
l9_0--;
continue;
}
else
{
break;
}
}
}
#endif
}
float getDepthOrderingEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 0.001;
}
#else
{
return 0.0;
}
#endif
}
int encodeDepth(float depth,vec2 depthBounds)
{
float l9_0=(1.0-depthBounds.x)*1000.0;
return int(clamp((depth-l9_0)/((depthBounds.y*1000.0)-l9_0),0.0,1.0)*65535.0);
}
float viewSpaceDepth()
{
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
return varViewSpaceDepth;
}
#else
{
return sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((gl_FragCoord.z*2.0)-1.0));
}
#endif
}
float packValue(inout int value)
{
#if (sc_OITDepthGatherPass)
{
int l9_0=value;
value/=4;
return floor(floor(mod(float(l9_0),4.0))*64.0)/255.0;
}
#else
{
return 0.0;
}
#endif
}
void main()
{
#if (sc_DepthOnly)
{
return;
}
#endif
#if ((sc_StereoRenderingMode==1)&&(sc_StereoRendering_IsClipDistanceEnabled==0))
{
if (varClipDistance<0.0)
{
discard;
}
}
#endif
bool l9_0=sc_RayTracingCasterConfiguration.x!=0u;
vec3 l9_1;
vec3 l9_2;
vec3 l9_3;
vec3 l9_4;
vec3 l9_5;
vec2 l9_6;
vec2 l9_7;
vec2 l9_8;
vec4 l9_9;
if (l9_0)
{
sc_RayTracingHitPayload l9_10=sc_RayTracingEvaluateHitPayload(ivec2(gl_FragCoord.xy));
vec3 l9_11=l9_10.positionWS;
vec3 l9_12=l9_10.normalWS;
vec4 l9_13=l9_10.tangentWS;
if (l9_10.id.x!=(sc_RayTracingCasterConfiguration.y&65535u))
{
return;
}
vec4 l9_14=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(l9_11,1.0);
vec3 l9_15=l9_13.xyz;
l9_9=l9_10.color;
l9_8=l9_10.uv0;
l9_7=l9_10.uv1;
l9_6=((l9_14.xy/vec2(l9_14.w))*0.5)+vec2(0.5);
l9_5=l9_10.viewDirWS;
l9_4=l9_11;
l9_3=l9_15;
l9_2=l9_12;
l9_1=cross(l9_12,l9_15)*l9_13.w;
}
else
{
vec3 l9_16=normalize(varTangent.xyz);
vec3 l9_17=normalize(varNormalAndMotion.xyz);
l9_9=varColor;
l9_8=varTex01.xy;
l9_7=varTex01.zw;
l9_6=sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw);
l9_5=normalize(sc_Camera.position-varPosAndMotion.xyz);
l9_4=varPosAndMotion.xyz;
l9_3=l9_16;
l9_2=l9_17;
l9_1=cross(l9_17,l9_16)*varTangent.w;
}
ssGlobals l9_18=ssGlobals(sc_Time.x,sc_Time.y,0.0,l9_9,l9_8,l9_7,l9_6,l9_5,l9_4,l9_3,l9_2,l9_1);
vec4 l9_19;
#if (NODE_38_DROPLIST_ITEM==1)
{
vec3 l9_20;
Node80_If_else(0.0,vec3(0.0),vec3(0.0),l9_20,l9_18);
l9_19=l9_9*vec4(l9_20.x,l9_20.y,l9_20.z,vec4(0.0).w);
}
#else
{
vec3 l9_21;
Node80_If_else(0.0,vec3(0.0),vec3(0.0),l9_21,l9_18);
l9_19=vec4(l9_21.x,l9_21.y,l9_21.z,vec4(0.0).w);
}
#endif
vec3 l9_22;
#if ((NODE_38_DROPLIST_ITEM==2)||ENABLE_EMISSIVE)
{
vec3 l9_23;
#if (NODE_38_DROPLIST_ITEM==2)
{
vec3 l9_24;
Node132_If_else(0.0,vec3(0.0),Port_Default_N132,l9_24,l9_18);
l9_23=l9_9.xyz+l9_24;
}
#else
{
vec3 l9_25;
Node132_If_else(0.0,vec3(0.0),Port_Default_N132,l9_25,l9_18);
l9_23=l9_25;
}
#endif
l9_22=ssSRGB_to_Linear((l9_23*emissiveColor)*vec3(emissiveIntensity));
}
#else
{
l9_22=Port_Default_N097;
}
#endif
vec3 l9_26;
#if (Tweak_N179)
{
vec3 l9_27;
Node337_If_else(0.0,vec3(0.0),vec3(0.0),l9_27,l9_18);
vec3 l9_28=l9_27;
vec3 l9_29=reflect(l9_5,l9_28);
vec3 l9_30=l9_29*Port_Input1_N257;
float l9_31=l9_30.x;
float l9_32=l9_30.y;
float l9_33=l9_30.z+Port_Input1_N264;
float l9_34=((l9_31*l9_31)+(l9_32*l9_32))+(l9_33*l9_33);
float l9_35;
if (l9_34<=0.0)
{
l9_35=0.0;
}
else
{
l9_35=sqrt(l9_34);
}
float l9_36=l9_35*Port_Input1_N268;
vec2 l9_37=vec2(1.0)-((vec2(l9_31,l9_32)/vec2(l9_36))+vec2(Port_Input1_N270));
vec4 l9_38;
#if (reflectionTexLayout==2)
{
bool l9_39=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_reflectionTex)!=0));
float l9_40=l9_37.x;
sc_SoftwareWrapEarly(l9_40,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x);
float l9_41=l9_40;
float l9_42=l9_37.y;
sc_SoftwareWrapEarly(l9_42,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y);
float l9_43=l9_42;
vec2 l9_44;
float l9_45;
#if (SC_USE_UV_MIN_MAX_reflectionTex)
{
bool l9_46;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_46=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x==3;
}
#else
{
l9_46=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0);
}
#endif
float l9_47=l9_41;
float l9_48=1.0;
sc_ClampUV(l9_47,reflectionTexUvMinMax.x,reflectionTexUvMinMax.z,l9_46,l9_48);
float l9_49=l9_47;
float l9_50=l9_48;
bool l9_51;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_51=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y==3;
}
#else
{
l9_51=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0);
}
#endif
float l9_52=l9_43;
float l9_53=l9_50;
sc_ClampUV(l9_52,reflectionTexUvMinMax.y,reflectionTexUvMinMax.w,l9_51,l9_53);
l9_45=l9_53;
l9_44=vec2(l9_49,l9_52);
}
#else
{
l9_45=1.0;
l9_44=vec2(l9_41,l9_43);
}
#endif
vec2 l9_54=sc_TransformUV(l9_44,(int(SC_USE_UV_TRANSFORM_reflectionTex)!=0),reflectionTexTransform);
float l9_55=l9_54.x;
float l9_56=l9_45;
sc_SoftwareWrapLate(l9_55,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x,l9_39,l9_56);
float l9_57=l9_54.y;
float l9_58=l9_56;
sc_SoftwareWrapLate(l9_57,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y,l9_39,l9_58);
float l9_59=l9_58;
vec3 l9_60=sc_SamplingCoordsViewToGlobal(vec2(l9_55,l9_57),reflectionTexLayout,reflectionTexGetStereoViewIndex());
vec4 l9_61=texture(reflectionTexArrSC,l9_60,0.0);
vec4 l9_62;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_62=mix(reflectionTexBorderColor,l9_61,vec4(l9_59));
}
#else
{
l9_62=l9_61;
}
#endif
l9_38=l9_62;
}
#else
{
bool l9_63=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_reflectionTex)!=0));
float l9_64=l9_37.x;
sc_SoftwareWrapEarly(l9_64,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x);
float l9_65=l9_64;
float l9_66=l9_37.y;
sc_SoftwareWrapEarly(l9_66,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y);
float l9_67=l9_66;
vec2 l9_68;
float l9_69;
#if (SC_USE_UV_MIN_MAX_reflectionTex)
{
bool l9_70;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_70=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x==3;
}
#else
{
l9_70=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0);
}
#endif
float l9_71=l9_65;
float l9_72=1.0;
sc_ClampUV(l9_71,reflectionTexUvMinMax.x,reflectionTexUvMinMax.z,l9_70,l9_72);
float l9_73=l9_71;
float l9_74=l9_72;
bool l9_75;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_75=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y==3;
}
#else
{
l9_75=(int(SC_USE_CLAMP_TO_BORDER_reflectionTex)!=0);
}
#endif
float l9_76=l9_67;
float l9_77=l9_74;
sc_ClampUV(l9_76,reflectionTexUvMinMax.y,reflectionTexUvMinMax.w,l9_75,l9_77);
l9_69=l9_77;
l9_68=vec2(l9_73,l9_76);
}
#else
{
l9_69=1.0;
l9_68=vec2(l9_65,l9_67);
}
#endif
vec2 l9_78=sc_TransformUV(l9_68,(int(SC_USE_UV_TRANSFORM_reflectionTex)!=0),reflectionTexTransform);
float l9_79=l9_78.x;
float l9_80=l9_69;
sc_SoftwareWrapLate(l9_79,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).x,l9_63,l9_80);
float l9_81=l9_78.y;
float l9_82=l9_80;
sc_SoftwareWrapLate(l9_81,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionTex,SC_SOFTWARE_WRAP_MODE_V_reflectionTex).y,l9_63,l9_82);
float l9_83=l9_82;
vec3 l9_84=sc_SamplingCoordsViewToGlobal(vec2(l9_79,l9_81),reflectionTexLayout,reflectionTexGetStereoViewIndex());
vec4 l9_85=texture(reflectionTex,l9_84.xy,0.0);
vec4 l9_86;
#if (SC_USE_CLAMP_TO_BORDER_reflectionTex)
{
l9_86=mix(reflectionTexBorderColor,l9_85,vec4(l9_83));
}
#else
{
l9_86=l9_85;
}
#endif
l9_38=l9_86;
}
#endif
vec3 l9_87;
#if (ENABLE_REFLECTION_MODULATION_TEX)
{
vec2 l9_88;
#if (NODE_228_DROPLIST_ITEM==0)
{
l9_88=l9_8;
}
#else
{
vec2 l9_89;
#if (NODE_228_DROPLIST_ITEM==1)
{
l9_89=l9_7;
}
#else
{
vec2 l9_90;
#if (NODE_228_DROPLIST_ITEM==2)
{
vec2 l9_91;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),l9_91,l9_18);
l9_90=l9_91;
}
#else
{
vec2 l9_92;
#if (NODE_228_DROPLIST_ITEM==3)
{
vec2 l9_93;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),l9_93,l9_18);
l9_92=l9_93;
}
#else
{
l9_92=l9_8;
}
#endif
l9_90=l9_92;
}
#endif
l9_89=l9_90;
}
#endif
l9_88=l9_89;
}
#endif
vec4 l9_94;
#if (reflectionModulationTexLayout==2)
{
bool l9_95=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_reflectionModulationTex)!=0));
float l9_96=l9_88.x;
sc_SoftwareWrapEarly(l9_96,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x);
float l9_97=l9_96;
float l9_98=l9_88.y;
sc_SoftwareWrapEarly(l9_98,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y);
float l9_99=l9_98;
vec2 l9_100;
float l9_101;
#if (SC_USE_UV_MIN_MAX_reflectionModulationTex)
{
bool l9_102;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_102=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x==3;
}
#else
{
l9_102=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0);
}
#endif
float l9_103=l9_97;
float l9_104=1.0;
sc_ClampUV(l9_103,reflectionModulationTexUvMinMax.x,reflectionModulationTexUvMinMax.z,l9_102,l9_104);
float l9_105=l9_103;
float l9_106=l9_104;
bool l9_107;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_107=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y==3;
}
#else
{
l9_107=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0);
}
#endif
float l9_108=l9_99;
float l9_109=l9_106;
sc_ClampUV(l9_108,reflectionModulationTexUvMinMax.y,reflectionModulationTexUvMinMax.w,l9_107,l9_109);
l9_101=l9_109;
l9_100=vec2(l9_105,l9_108);
}
#else
{
l9_101=1.0;
l9_100=vec2(l9_97,l9_99);
}
#endif
vec2 l9_110=sc_TransformUV(l9_100,(int(SC_USE_UV_TRANSFORM_reflectionModulationTex)!=0),reflectionModulationTexTransform);
float l9_111=l9_110.x;
float l9_112=l9_101;
sc_SoftwareWrapLate(l9_111,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x,l9_95,l9_112);
float l9_113=l9_110.y;
float l9_114=l9_112;
sc_SoftwareWrapLate(l9_113,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y,l9_95,l9_114);
float l9_115=l9_114;
vec3 l9_116=sc_SamplingCoordsViewToGlobal(vec2(l9_111,l9_113),reflectionModulationTexLayout,reflectionModulationTexGetStereoViewIndex());
vec4 l9_117=texture(reflectionModulationTexArrSC,l9_116,0.0);
vec4 l9_118;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_118=mix(reflectionModulationTexBorderColor,l9_117,vec4(l9_115));
}
#else
{
l9_118=l9_117;
}
#endif
l9_94=l9_118;
}
#else
{
bool l9_119=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_reflectionModulationTex)!=0));
float l9_120=l9_88.x;
sc_SoftwareWrapEarly(l9_120,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x);
float l9_121=l9_120;
float l9_122=l9_88.y;
sc_SoftwareWrapEarly(l9_122,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y);
float l9_123=l9_122;
vec2 l9_124;
float l9_125;
#if (SC_USE_UV_MIN_MAX_reflectionModulationTex)
{
bool l9_126;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_126=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x==3;
}
#else
{
l9_126=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0);
}
#endif
float l9_127=l9_121;
float l9_128=1.0;
sc_ClampUV(l9_127,reflectionModulationTexUvMinMax.x,reflectionModulationTexUvMinMax.z,l9_126,l9_128);
float l9_129=l9_127;
float l9_130=l9_128;
bool l9_131;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_131=ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y==3;
}
#else
{
l9_131=(int(SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)!=0);
}
#endif
float l9_132=l9_123;
float l9_133=l9_130;
sc_ClampUV(l9_132,reflectionModulationTexUvMinMax.y,reflectionModulationTexUvMinMax.w,l9_131,l9_133);
l9_125=l9_133;
l9_124=vec2(l9_129,l9_132);
}
#else
{
l9_125=1.0;
l9_124=vec2(l9_121,l9_123);
}
#endif
vec2 l9_134=sc_TransformUV(l9_124,(int(SC_USE_UV_TRANSFORM_reflectionModulationTex)!=0),reflectionModulationTexTransform);
float l9_135=l9_134.x;
float l9_136=l9_125;
sc_SoftwareWrapLate(l9_135,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).x,l9_119,l9_136);
float l9_137=l9_134.y;
float l9_138=l9_136;
sc_SoftwareWrapLate(l9_137,ivec2(SC_SOFTWARE_WRAP_MODE_U_reflectionModulationTex,SC_SOFTWARE_WRAP_MODE_V_reflectionModulationTex).y,l9_119,l9_138);
float l9_139=l9_138;
vec3 l9_140=sc_SamplingCoordsViewToGlobal(vec2(l9_135,l9_137),reflectionModulationTexLayout,reflectionModulationTexGetStereoViewIndex());
vec4 l9_141=texture(reflectionModulationTex,l9_140.xy,0.0);
vec4 l9_142;
#if (SC_USE_CLAMP_TO_BORDER_reflectionModulationTex)
{
l9_142=mix(reflectionModulationTexBorderColor,l9_141,vec4(l9_139));
}
#else
{
l9_142=l9_141;
}
#endif
l9_94=l9_142;
}
#endif
l9_87=l9_94.xyz;
}
#else
{
l9_87=Port_Default_N041;
}
#endif
l9_26=vec3(reflectionIntensity)*ssSRGB_to_Linear(l9_38.xyz*l9_87);
}
#else
{
l9_26=Port_Default_N134;
}
#endif
vec3 l9_143;
#if (ENABLE_RIM_HIGHLIGHT)
{
vec3 l9_144;
#if (ENABLE_RIM_COLOR_TEX)
{
vec2 l9_145;
#if (NODE_315_DROPLIST_ITEM==0)
{
l9_145=l9_8;
}
#else
{
vec2 l9_146;
#if (NODE_315_DROPLIST_ITEM==1)
{
l9_146=l9_7;
}
#else
{
vec2 l9_147;
#if (NODE_315_DROPLIST_ITEM==2)
{
vec2 l9_148;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),l9_148,l9_18);
l9_147=l9_148;
}
#else
{
vec2 l9_149;
#if (NODE_315_DROPLIST_ITEM==3)
{
vec2 l9_150;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),l9_150,l9_18);
l9_149=l9_150;
}
#else
{
l9_149=l9_8;
}
#endif
l9_147=l9_149;
}
#endif
l9_146=l9_147;
}
#endif
l9_145=l9_146;
}
#endif
vec4 l9_151;
#if (rimColorTexLayout==2)
{
bool l9_152=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_rimColorTex)!=0));
float l9_153=l9_145.x;
sc_SoftwareWrapEarly(l9_153,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x);
float l9_154=l9_153;
float l9_155=l9_145.y;
sc_SoftwareWrapEarly(l9_155,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y);
float l9_156=l9_155;
vec2 l9_157;
float l9_158;
#if (SC_USE_UV_MIN_MAX_rimColorTex)
{
bool l9_159;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_159=ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x==3;
}
#else
{
l9_159=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0);
}
#endif
float l9_160=l9_154;
float l9_161=1.0;
sc_ClampUV(l9_160,rimColorTexUvMinMax.x,rimColorTexUvMinMax.z,l9_159,l9_161);
float l9_162=l9_160;
float l9_163=l9_161;
bool l9_164;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_164=ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y==3;
}
#else
{
l9_164=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0);
}
#endif
float l9_165=l9_156;
float l9_166=l9_163;
sc_ClampUV(l9_165,rimColorTexUvMinMax.y,rimColorTexUvMinMax.w,l9_164,l9_166);
l9_158=l9_166;
l9_157=vec2(l9_162,l9_165);
}
#else
{
l9_158=1.0;
l9_157=vec2(l9_154,l9_156);
}
#endif
vec2 l9_167=sc_TransformUV(l9_157,(int(SC_USE_UV_TRANSFORM_rimColorTex)!=0),rimColorTexTransform);
float l9_168=l9_167.x;
float l9_169=l9_158;
sc_SoftwareWrapLate(l9_168,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x,l9_152,l9_169);
float l9_170=l9_167.y;
float l9_171=l9_169;
sc_SoftwareWrapLate(l9_170,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y,l9_152,l9_171);
float l9_172=l9_171;
vec3 l9_173=sc_SamplingCoordsViewToGlobal(vec2(l9_168,l9_170),rimColorTexLayout,rimColorTexGetStereoViewIndex());
vec4 l9_174=texture(rimColorTexArrSC,l9_173,0.0);
vec4 l9_175;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_175=mix(rimColorTexBorderColor,l9_174,vec4(l9_172));
}
#else
{
l9_175=l9_174;
}
#endif
l9_151=l9_175;
}
#else
{
bool l9_176=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_rimColorTex)!=0));
float l9_177=l9_145.x;
sc_SoftwareWrapEarly(l9_177,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x);
float l9_178=l9_177;
float l9_179=l9_145.y;
sc_SoftwareWrapEarly(l9_179,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y);
float l9_180=l9_179;
vec2 l9_181;
float l9_182;
#if (SC_USE_UV_MIN_MAX_rimColorTex)
{
bool l9_183;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_183=ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x==3;
}
#else
{
l9_183=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0);
}
#endif
float l9_184=l9_178;
float l9_185=1.0;
sc_ClampUV(l9_184,rimColorTexUvMinMax.x,rimColorTexUvMinMax.z,l9_183,l9_185);
float l9_186=l9_184;
float l9_187=l9_185;
bool l9_188;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_188=ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y==3;
}
#else
{
l9_188=(int(SC_USE_CLAMP_TO_BORDER_rimColorTex)!=0);
}
#endif
float l9_189=l9_180;
float l9_190=l9_187;
sc_ClampUV(l9_189,rimColorTexUvMinMax.y,rimColorTexUvMinMax.w,l9_188,l9_190);
l9_182=l9_190;
l9_181=vec2(l9_186,l9_189);
}
#else
{
l9_182=1.0;
l9_181=vec2(l9_178,l9_180);
}
#endif
vec2 l9_191=sc_TransformUV(l9_181,(int(SC_USE_UV_TRANSFORM_rimColorTex)!=0),rimColorTexTransform);
float l9_192=l9_191.x;
float l9_193=l9_182;
sc_SoftwareWrapLate(l9_192,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).x,l9_176,l9_193);
float l9_194=l9_191.y;
float l9_195=l9_193;
sc_SoftwareWrapLate(l9_194,ivec2(SC_SOFTWARE_WRAP_MODE_U_rimColorTex,SC_SOFTWARE_WRAP_MODE_V_rimColorTex).y,l9_176,l9_195);
float l9_196=l9_195;
vec3 l9_197=sc_SamplingCoordsViewToGlobal(vec2(l9_192,l9_194),rimColorTexLayout,rimColorTexGetStereoViewIndex());
vec4 l9_198=texture(rimColorTex,l9_197.xy,0.0);
vec4 l9_199;
#if (SC_USE_CLAMP_TO_BORDER_rimColorTex)
{
l9_199=mix(rimColorTexBorderColor,l9_198,vec4(l9_196));
}
#else
{
l9_199=l9_198;
}
#endif
l9_151=l9_199;
}
#endif
l9_144=l9_151.xyz;
}
#else
{
l9_144=Port_Default_N170;
}
#endif
vec3 l9_200=ssSRGB_to_Linear((rimColor*vec3(rimIntensity))*l9_144);
float l9_201;
#if (ENABLE_RIM_INVERT)
{
vec3 l9_202;
Node337_If_else(0.0,vec3(0.0),vec3(0.0),l9_202,l9_18);
l9_201=abs(dot(l9_202,-l9_5));
}
#else
{
vec3 l9_203;
Node337_If_else(0.0,vec3(0.0),vec3(0.0),l9_203,l9_18);
l9_201=1.0-abs(dot(l9_203,-l9_5));
}
#endif
float l9_204;
if (l9_201<=0.0)
{
l9_204=0.0;
}
else
{
l9_204=pow(l9_201,rimExponent);
}
l9_143=l9_200*vec3(l9_204);
}
#else
{
l9_143=Port_Default_N173;
}
#endif
vec3 l9_205=l9_22+l9_26;
vec3 l9_206=l9_205+l9_143;
vec3 l9_207;
#if (SC_DEVICE_CLASS>=2)
{
l9_207=vec3(pow(l9_206.x,0.45454544),pow(l9_206.y,0.45454544),pow(l9_206.z,0.45454544));
}
#else
{
l9_207=sqrt(l9_206);
}
#endif
vec3 l9_208=l9_19.xyz+l9_207;
vec4 param_4;
Node369_If_else(0.0,vec4(0.0),Port_Default_N369,param_4,l9_18);
vec4 l9_209=param_4;
float l9_210;
#if (ENABLE_OPACITY_TEX)
{
vec2 l9_211;
#if (NODE_69_DROPLIST_ITEM==0)
{
l9_211=l9_8;
}
#else
{
vec2 l9_212;
#if (NODE_69_DROPLIST_ITEM==1)
{
l9_212=l9_7;
}
#else
{
vec2 l9_213;
#if (NODE_69_DROPLIST_ITEM==2)
{
vec2 l9_214;
Node79_If_else(0.0,vec2(0.0),vec2(0.0),l9_214,l9_18);
l9_213=l9_214;
}
#else
{
vec2 l9_215;
#if (NODE_69_DROPLIST_ITEM==3)
{
vec2 l9_216;
Node35_If_else(0.0,vec2(0.0),vec2(0.0),l9_216,l9_18);
l9_215=l9_216;
}
#else
{
l9_215=l9_8;
}
#endif
l9_213=l9_215;
}
#endif
l9_212=l9_213;
}
#endif
l9_211=l9_212;
}
#endif
vec4 l9_217;
#if (opacityTexLayout==2)
{
bool l9_218=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_opacityTex)!=0));
float l9_219=l9_211.x;
sc_SoftwareWrapEarly(l9_219,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x);
float l9_220=l9_219;
float l9_221=l9_211.y;
sc_SoftwareWrapEarly(l9_221,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y);
float l9_222=l9_221;
vec2 l9_223;
float l9_224;
#if (SC_USE_UV_MIN_MAX_opacityTex)
{
bool l9_225;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_225=ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x==3;
}
#else
{
l9_225=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0);
}
#endif
float l9_226=l9_220;
float l9_227=1.0;
sc_ClampUV(l9_226,opacityTexUvMinMax.x,opacityTexUvMinMax.z,l9_225,l9_227);
float l9_228=l9_226;
float l9_229=l9_227;
bool l9_230;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_230=ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y==3;
}
#else
{
l9_230=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0);
}
#endif
float l9_231=l9_222;
float l9_232=l9_229;
sc_ClampUV(l9_231,opacityTexUvMinMax.y,opacityTexUvMinMax.w,l9_230,l9_232);
l9_224=l9_232;
l9_223=vec2(l9_228,l9_231);
}
#else
{
l9_224=1.0;
l9_223=vec2(l9_220,l9_222);
}
#endif
vec2 l9_233=sc_TransformUV(l9_223,(int(SC_USE_UV_TRANSFORM_opacityTex)!=0),opacityTexTransform);
float l9_234=l9_233.x;
float l9_235=l9_224;
sc_SoftwareWrapLate(l9_234,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x,l9_218,l9_235);
float l9_236=l9_233.y;
float l9_237=l9_235;
sc_SoftwareWrapLate(l9_236,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y,l9_218,l9_237);
float l9_238=l9_237;
vec3 l9_239=sc_SamplingCoordsViewToGlobal(vec2(l9_234,l9_236),opacityTexLayout,opacityTexGetStereoViewIndex());
vec4 l9_240=texture(opacityTexArrSC,l9_239,0.0);
vec4 l9_241;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_241=mix(opacityTexBorderColor,l9_240,vec4(l9_238));
}
#else
{
l9_241=l9_240;
}
#endif
l9_217=l9_241;
}
#else
{
bool l9_242=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_opacityTex)!=0));
float l9_243=l9_211.x;
sc_SoftwareWrapEarly(l9_243,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x);
float l9_244=l9_243;
float l9_245=l9_211.y;
sc_SoftwareWrapEarly(l9_245,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y);
float l9_246=l9_245;
vec2 l9_247;
float l9_248;
#if (SC_USE_UV_MIN_MAX_opacityTex)
{
bool l9_249;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_249=ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x==3;
}
#else
{
l9_249=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0);
}
#endif
float l9_250=l9_244;
float l9_251=1.0;
sc_ClampUV(l9_250,opacityTexUvMinMax.x,opacityTexUvMinMax.z,l9_249,l9_251);
float l9_252=l9_250;
float l9_253=l9_251;
bool l9_254;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_254=ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y==3;
}
#else
{
l9_254=(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0);
}
#endif
float l9_255=l9_246;
float l9_256=l9_253;
sc_ClampUV(l9_255,opacityTexUvMinMax.y,opacityTexUvMinMax.w,l9_254,l9_256);
l9_248=l9_256;
l9_247=vec2(l9_252,l9_255);
}
#else
{
l9_248=1.0;
l9_247=vec2(l9_244,l9_246);
}
#endif
vec2 l9_257=sc_TransformUV(l9_247,(int(SC_USE_UV_TRANSFORM_opacityTex)!=0),opacityTexTransform);
float l9_258=l9_257.x;
float l9_259=l9_248;
sc_SoftwareWrapLate(l9_258,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).x,l9_242,l9_259);
float l9_260=l9_257.y;
float l9_261=l9_259;
sc_SoftwareWrapLate(l9_260,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex).y,l9_242,l9_261);
float l9_262=l9_261;
vec3 l9_263=sc_SamplingCoordsViewToGlobal(vec2(l9_258,l9_260),opacityTexLayout,opacityTexGetStereoViewIndex());
vec4 l9_264=texture(opacityTex,l9_263.xy,0.0);
vec4 l9_265;
#if (SC_USE_CLAMP_TO_BORDER_opacityTex)
{
l9_265=mix(opacityTexBorderColor,l9_264,vec4(l9_262));
}
#else
{
l9_265=l9_264;
}
#endif
l9_217=l9_265;
}
#endif
l9_210=l9_217.x;
}
#else
{
l9_210=Port_Default_N204;
}
#endif
float l9_266;
#if (NODE_38_DROPLIST_ITEM==1)
{
l9_266=l9_9.w;
}
#else
{
l9_266=Port_Input2_N072;
}
#endif
float l9_267=(baseColor*l9_209).w*l9_210;
float l9_268=l9_267*l9_266;
vec4 l9_269=vec4(l9_208.x,l9_208.y,l9_208.z,vec4(0.0).w);
l9_269.w=l9_268;
#if (sc_BlendMode_AlphaTest)
{
if (l9_268<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (l9_268<((mod(dot(floor(mod(gl_FragCoord.xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)/17.0))
{
discard;
}
}
#endif
if (l9_0)
{
vec4 l9_270;
#if (sc_RayTracingCasterForceOpaque)
{
vec4 l9_271=l9_269;
l9_271.w=1.0;
l9_270=l9_271;
}
#else
{
l9_270=l9_269;
}
#endif
sc_writeFragData0(max(l9_270,vec4(0.0)));
return;
}
vec4 l9_272;
#if (sc_ProjectiveShadowsCaster)
{
float l9_273;
#if (((sc_BlendMode_Normal||sc_BlendMode_AlphaToCoverage)||sc_BlendMode_PremultipliedAlphaHardware)||sc_BlendMode_PremultipliedAlphaAuto)
{
l9_273=l9_268;
}
#else
{
float l9_274;
#if (sc_BlendMode_PremultipliedAlpha)
{
l9_274=clamp(l9_268*2.0,0.0,1.0);
}
#else
{
float l9_275;
#if (sc_BlendMode_AddWithAlphaFactor)
{
l9_275=clamp(dot(l9_269.xyz,vec3(l9_268)),0.0,1.0);
}
#else
{
float l9_276;
#if (sc_BlendMode_AlphaTest)
{
l9_276=1.0;
}
#else
{
float l9_277;
#if (sc_BlendMode_Multiply)
{
l9_277=(1.0-dot(l9_269.xyz,vec3(0.33333001)))*l9_268;
}
#else
{
float l9_278;
#if (sc_BlendMode_MultiplyOriginal)
{
l9_278=(1.0-clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0))*l9_268;
}
#else
{
float l9_279;
#if (sc_BlendMode_ColoredGlass)
{
l9_279=clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0)*l9_268;
}
#else
{
float l9_280;
#if (sc_BlendMode_Add)
{
l9_280=clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_281;
#if (sc_BlendMode_AddWithAlphaFactor)
{
l9_281=clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0)*l9_268;
}
#else
{
float l9_282;
#if (sc_BlendMode_Screen)
{
l9_282=dot(l9_269.xyz,vec3(0.33333001))*l9_268;
}
#else
{
float l9_283;
#if (sc_BlendMode_Min)
{
l9_283=1.0-clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_284;
#if (sc_BlendMode_Max)
{
l9_284=clamp(dot(l9_269.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
l9_284=1.0;
}
#endif
l9_283=l9_284;
}
#endif
l9_282=l9_283;
}
#endif
l9_281=l9_282;
}
#endif
l9_280=l9_281;
}
#endif
l9_279=l9_280;
}
#endif
l9_278=l9_279;
}
#endif
l9_277=l9_278;
}
#endif
l9_276=l9_277;
}
#endif
l9_275=l9_276;
}
#endif
l9_274=l9_275;
}
#endif
l9_273=l9_274;
}
#endif
l9_272=vec4(mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_269.xyz,vec3(sc_ShadowColor.w)),sc_ShadowDensity*l9_273);
}
#else
{
vec4 l9_285;
#if (sc_RenderAlphaToColor)
{
l9_285=vec4(l9_268);
}
#else
{
vec4 l9_286;
#if (sc_BlendMode_Custom)
{
vec4 l9_287;
#if (sc_FramebufferFetch)
{
l9_287=sc_readFragData0();
}
#else
{
vec2 l9_288=sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw);
vec4 l9_289;
#if (sc_ScreenTextureLayout==2)
{
l9_289=texture(sc_ScreenTextureArrSC,sc_SamplingCoordsViewToGlobal(l9_288,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()),0.0);
}
#else
{
l9_289=texture(sc_ScreenTexture,sc_SamplingCoordsViewToGlobal(l9_288,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()).xy,0.0);
}
#endif
l9_287=l9_289;
}
#endif
vec3 l9_290=mix(l9_287.xyz,definedBlend(l9_287.xyz,l9_269.xyz).xyz,vec3(l9_268));
vec4 l9_291=vec4(l9_290.x,l9_290.y,l9_290.z,vec4(0.0).w);
l9_291.w=1.0;
l9_286=l9_291;
}
#else
{
vec4 l9_292;
#if (sc_Voxelization)
{
l9_292=vec4(varScreenPos.xyz,1.0);
}
#else
{
vec4 l9_293;
#if (sc_OutputBounds)
{
float l9_294=clamp(abs(gl_FragCoord.z),0.0,1.0);
l9_293=vec4(l9_294,1.0-l9_294,1.0,1.0);
}
#else
{
vec4 l9_295;
#if (sc_BlendMode_MultiplyOriginal)
{
l9_295=vec4(mix(vec3(1.0),l9_269.xyz,vec3(l9_268)),l9_268);
}
#else
{
vec4 l9_296;
#if (sc_BlendMode_Screen||sc_BlendMode_PremultipliedAlphaAuto)
{
float l9_297;
#if (sc_BlendMode_PremultipliedAlphaAuto)
{
l9_297=clamp(l9_268,0.0,1.0);
}
#else
{
l9_297=l9_268;
}
#endif
l9_296=vec4(l9_269.xyz*l9_297,l9_297);
}
#else
{
l9_296=l9_269;
}
#endif
l9_295=l9_296;
}
#endif
l9_293=l9_295;
}
#endif
l9_292=l9_293;
}
#endif
l9_286=l9_292;
}
#endif
l9_285=l9_286;
}
#endif
l9_272=l9_285;
}
#endif
vec4 l9_298;
if (PreviewEnabled==1)
{
vec4 l9_299;
if (((PreviewVertexSaved*1.0)!=0.0) ? true : false)
{
l9_299=PreviewVertexColor;
}
else
{
l9_299=vec4(0.0);
}
l9_298=l9_299;
}
else
{
l9_298=l9_272;
}
vec4 l9_300=sc_OutputMotionVectorIfNeeded(max(l9_298,vec4(0.0)));
vec4 l9_301=clamp(l9_300,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_302=clamp(viewSpaceDepth()/1000.0,0.0,1.0);
sc_writeFragData0(vec4(max(0.0,1.0-(l9_302-0.0039215689)),min(1.0,l9_302+0.0039215689),0.0,0.0));
}
#endif
}
#else
{
#if (sc_OITDepthPrepass)
{
sc_writeFragData0(vec4(1.0));
}
#else
{
#if (sc_OITDepthGatherPass)
{
#if (sc_OITDepthGatherPass)
{
vec2 l9_303=sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_303).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_304=encodeDepth(viewSpaceDepth(),texture(sc_OITFilteredDepthBoundsTexture,l9_303).xy);
float l9_305=packValue(l9_304);
int l9_312=int(l9_301.w*255.0);
float l9_313=packValue(l9_312);
sc_writeFragData0(vec4(packValue(l9_304),packValue(l9_304),packValue(l9_304),packValue(l9_304)));
}
#endif
}
#else
{
#if (sc_OITCompositingPass)
{
#if (sc_OITCompositingPass)
{
vec2 l9_316=sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_316).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_317[8];
int l9_318[8];
int l9_319=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_319<8)
{
l9_317[l9_319]=0;
l9_318[l9_319]=0;
l9_319++;
continue;
}
else
{
break;
}
}
int l9_320;
#if (sc_OITMaxLayers8)
{
l9_320=2;
}
#else
{
l9_320=1;
}
#endif
int l9_321=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_321<l9_320)
{
vec4 l9_322;
vec4 l9_323;
vec4 l9_324;
if (l9_321==0)
{
l9_324=texture(sc_OITAlpha0,l9_316);
l9_323=texture(sc_OITDepthLow0,l9_316);
l9_322=texture(sc_OITDepthHigh0,l9_316);
}
else
{
l9_324=vec4(0.0);
l9_323=vec4(0.0);
l9_322=vec4(0.0);
}
vec4 l9_325;
vec4 l9_326;
vec4 l9_327;
if (l9_321==1)
{
l9_327=texture(sc_OITAlpha1,l9_316);
l9_326=texture(sc_OITDepthLow1,l9_316);
l9_325=texture(sc_OITDepthHigh1,l9_316);
}
else
{
l9_327=l9_324;
l9_326=l9_323;
l9_325=l9_322;
}
if (any(notEqual(l9_325,vec4(0.0)))||any(notEqual(l9_326,vec4(0.0))))
{
int l9_328[8]=l9_317;
unpackValues(l9_325.w,l9_321,l9_328);
unpackValues(l9_325.z,l9_321,l9_328);
unpackValues(l9_325.y,l9_321,l9_328);
unpackValues(l9_325.x,l9_321,l9_328);
unpackValues(l9_326.w,l9_321,l9_328);
unpackValues(l9_326.z,l9_321,l9_328);
unpackValues(l9_326.y,l9_321,l9_328);
unpackValues(l9_326.x,l9_321,l9_328);
int l9_337[8]=l9_318;
unpackValues(l9_327.w,l9_321,l9_337);
unpackValues(l9_327.z,l9_321,l9_337);
unpackValues(l9_327.y,l9_321,l9_337);
unpackValues(l9_327.x,l9_321,l9_337);
}
l9_321++;
continue;
}
else
{
break;
}
}
vec4 l9_342=texture(sc_OITFilteredDepthBoundsTexture,l9_316);
vec2 l9_343=l9_342.xy;
int l9_344;
#if (sc_SkinBonesCount>0)
{
l9_344=encodeDepth(((1.0-l9_342.x)*1000.0)+getDepthOrderingEpsilon(),l9_343);
}
#else
{
l9_344=0;
}
#endif
int l9_345=encodeDepth(viewSpaceDepth(),l9_343);
vec4 l9_346;
l9_346=l9_301*l9_301.w;
vec4 l9_347;
int l9_348=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_348<8)
{
int l9_349=l9_317[l9_348];
int l9_350=l9_345-l9_344;
bool l9_351=l9_349<l9_350;
bool l9_352;
if (l9_351)
{
l9_352=l9_317[l9_348]>0;
}
else
{
l9_352=l9_351;
}
if (l9_352)
{
vec3 l9_353=l9_346.xyz*(1.0-(float(l9_318[l9_348])/255.0));
l9_347=vec4(l9_353.x,l9_353.y,l9_353.z,l9_346.w);
}
else
{
l9_347=l9_346;
}
l9_346=l9_347;
l9_348++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(l9_346);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
discard;
}
#endif
}
#endif
}
#else
{
#if (sc_OITFrontLayerPass)
{
#if (sc_OITFrontLayerPass)
{
if (abs(gl_FragCoord.z-texture(sc_OITFrontDepthTexture,sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw)).x)>getFrontLayerZTestEpsilon())
{
discard;
}
sc_writeFragData0(l9_301);
}
#endif
}
#else
{
sc_writeFragData0(l9_300);
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
