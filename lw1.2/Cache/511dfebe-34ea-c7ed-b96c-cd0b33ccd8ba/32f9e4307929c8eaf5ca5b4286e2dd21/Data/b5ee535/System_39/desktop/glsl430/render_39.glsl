#version 430
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//output vec4 sc_FragData0 0
//sampler sampler intensityTextureSmpSC 0:21
//sampler sampler renderTarget0SmpSC 0:22
//sampler sampler renderTarget1SmpSC 0:23
//sampler sampler renderTarget2SmpSC 0:24
//sampler sampler renderTarget3SmpSC 0:25
//sampler sampler sc_ScreenTextureSmpSC 0:30
//texture texture2D intensityTexture 0:0:0:21
//texture texture2D renderTarget0 0:1:0:22
//texture texture2D renderTarget1 0:2:0:23
//texture texture2D renderTarget2 0:3:0:24
//texture texture2D renderTarget3 0:4:0:25
//texture texture2D sc_ScreenTexture 0:16:0:30
//texture texture2DArray intensityTextureArrSC 0:35:0:21
//texture texture2DArray renderTarget0ArrSC 0:36:0:22
//texture texture2DArray renderTarget1ArrSC 0:37:0:23
//texture texture2DArray renderTarget2ArrSC 0:38:0:24
//texture texture2DArray renderTarget3ArrSC 0:39:0:25
//texture texture2DArray sc_ScreenTextureArrSC 0:42:0:30
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
//spec_const bool SC_USE_CLAMP_TO_BORDER_intensityTexture 30 0
//spec_const bool SC_USE_UV_MIN_MAX_intensityTexture 31 0
//spec_const bool SC_USE_UV_TRANSFORM_intensityTexture 32 0
//spec_const bool intensityTextureHasSwappedViews 33 0
//spec_const bool renderTarget0HasSwappedViews 34 0
//spec_const bool renderTarget1HasSwappedViews 35 0
//spec_const bool renderTarget2HasSwappedViews 36 0
//spec_const bool renderTarget3HasSwappedViews 37 0
//spec_const bool sc_BlendMode_Custom 38 0
//spec_const bool sc_BlendMode_MultiplyOriginal 39 0
//spec_const bool sc_BlendMode_PremultipliedAlphaAuto 40 0
//spec_const bool sc_BlendMode_Screen 41 0
//spec_const bool sc_FramebufferFetch 42 0
//spec_const bool sc_MotionVectorsPass 43 0
//spec_const bool sc_OutputBounds 44 0
//spec_const bool sc_RenderAlphaToColor 45 0
//spec_const bool sc_ScreenTextureHasSwappedViews 46 0
//spec_const bool sc_Voxelization 47 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_intensityTexture 48 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_intensityTexture 49 -1
//spec_const int intensityTextureLayout 50 0
//spec_const int renderTarget0Layout 51 0
//spec_const int renderTarget1Layout 52 0
//spec_const int renderTarget2Layout 53 0
//spec_const int renderTarget3Layout 54 0
//spec_const int sc_DepthBufferMode 55 0
//spec_const int sc_ScreenTextureLayout 56 0
//spec_const int sc_ShaderCacheConstant 57 0
//spec_const int sc_StereoRenderingMode 58 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 59 0
//spec_const int sc_StereoViewID 60 0
//SG_REFLECTION_END
#define SC_ENABLE_INSTANCED_RENDERING
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
struct ssParticle
{
vec3 Position;
vec3 Velocity;
vec4 Color;
float Size;
float Age;
float Life;
float Mass;
mat3 Matrix;
bool Dead;
vec4 Quaternion;
float SpawnIndex;
float SpawnIndexRemainder;
float NextBurstTime;
float SpawnOffset;
float Seed;
vec2 Seed2000;
float TimeShift;
int Index1D;
int Index1DPerCopy;
float Index1DPerCopyF;
int StateID;
float Coord1D;
float Ratio1D;
float Ratio1DPerCopy;
ivec2 Index2D;
vec2 Coord2D;
vec2 Ratio2D;
vec3 Force;
bool Spawned;
float CopyId;
float SpawnAmount;
float BurstAmount;
float BurstPeriod;
};
struct ssGlobals
{
float gTimeElapsed;
float gTimeDelta;
float gTimeElapsedShifted;
vec2 Surface_UVCoord0;
float gComponentTime;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
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
#ifndef renderTarget0HasSwappedViews
#define renderTarget0HasSwappedViews 0
#elif renderTarget0HasSwappedViews==1
#undef renderTarget0HasSwappedViews
#define renderTarget0HasSwappedViews 1
#endif
#ifndef renderTarget0Layout
#define renderTarget0Layout 0
#endif
#ifndef renderTarget1HasSwappedViews
#define renderTarget1HasSwappedViews 0
#elif renderTarget1HasSwappedViews==1
#undef renderTarget1HasSwappedViews
#define renderTarget1HasSwappedViews 1
#endif
#ifndef renderTarget1Layout
#define renderTarget1Layout 0
#endif
#ifndef renderTarget2HasSwappedViews
#define renderTarget2HasSwappedViews 0
#elif renderTarget2HasSwappedViews==1
#undef renderTarget2HasSwappedViews
#define renderTarget2HasSwappedViews 1
#endif
#ifndef renderTarget2Layout
#define renderTarget2Layout 0
#endif
#ifndef renderTarget3HasSwappedViews
#define renderTarget3HasSwappedViews 0
#elif renderTarget3HasSwappedViews==1
#undef renderTarget3HasSwappedViews
#define renderTarget3HasSwappedViews 1
#endif
#ifndef renderTarget3Layout
#define renderTarget3Layout 0
#endif
uniform int sc_FallbackInstanceID;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed[32];
uniform vec4 sc_Time;
uniform int vfxOffsetInstancesRead;
uniform int vfxTargetWidth;
uniform vec2 vfxTargetSizeRead;
uniform bool vfxBatchEnable[32];
uniform float Port_Value_N172;
uniform float Port_RangeMinA_N169;
uniform float Port_RangeMaxA_N169;
uniform float Port_RangeMinB_N169;
uniform float Port_RangeMaxB_N169;
uniform float Port_Input1_N093;
uniform int vfxNumCopies;
uniform float overrideTimeDelta;
uniform mat4 vfxModelMatrix[32];
uniform float Port_Input1_N037;
uniform vec3 Port_Input1_N181;
uniform float Port_Input1_N171;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform sampler2DArray renderTarget0ArrSC;
uniform sampler2D renderTarget0;
uniform sampler2DArray renderTarget1ArrSC;
uniform sampler2D renderTarget1;
uniform sampler2DArray renderTarget2ArrSC;
uniform sampler2D renderTarget2;
uniform sampler2DArray renderTarget3ArrSC;
uniform sampler2D renderTarget3;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
out vec4 varPosAndMotion;
out vec4 varTangent;
out vec4 varNormalAndMotion;
out vec4 varTex01;
flat out int Interp_Particle_Index;
out vec3 Interp_Particle_Force;
out vec3 Interp_Particle_Position;
out vec3 Interp_Particle_Velocity;
out float Interp_Particle_Life;
out float Interp_Particle_Age;
out float Interp_Particle_Size;
out vec4 Interp_Particle_Color;
out vec4 Interp_Particle_Quaternion;
out float Interp_Particle_Mass;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out vec4 varColor;
out vec2 Interp_Particle_Coord;
out float Interp_Particle_SpawnIndex;
out float Interp_Particle_NextBurstTime;
out float gParticlesDebug;
out vec2 ParticleUV;
int ssInstanceID;
ssParticle gParticle;
int sc_GetLocalInstanceIDInternal(int id)
{
#ifdef sc_LocalInstanceID
return sc_LocalInstanceID;
#else
return 0;
#endif
}
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
int renderTarget0GetStereoViewIndex()
{
int l9_0;
#if (renderTarget0HasSwappedViews)
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
vec4 renderTarget0SampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (renderTarget0Layout==2)
{
l9_0=textureLod(renderTarget0ArrSC,sc_SamplingCoordsViewToGlobal(uv,renderTarget0Layout,renderTarget0GetStereoViewIndex()),0.0);
}
#else
{
l9_0=textureLod(renderTarget0,sc_SamplingCoordsViewToGlobal(uv,renderTarget0Layout,renderTarget0GetStereoViewIndex()).xy,0.0);
}
#endif
return l9_0;
}
int renderTarget1GetStereoViewIndex()
{
int l9_0;
#if (renderTarget1HasSwappedViews)
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
vec4 renderTarget1SampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (renderTarget1Layout==2)
{
l9_0=textureLod(renderTarget1ArrSC,sc_SamplingCoordsViewToGlobal(uv,renderTarget1Layout,renderTarget1GetStereoViewIndex()),0.0);
}
#else
{
l9_0=textureLod(renderTarget1,sc_SamplingCoordsViewToGlobal(uv,renderTarget1Layout,renderTarget1GetStereoViewIndex()).xy,0.0);
}
#endif
return l9_0;
}
int renderTarget2GetStereoViewIndex()
{
int l9_0;
#if (renderTarget2HasSwappedViews)
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
vec4 renderTarget2SampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (renderTarget2Layout==2)
{
l9_0=textureLod(renderTarget2ArrSC,sc_SamplingCoordsViewToGlobal(uv,renderTarget2Layout,renderTarget2GetStereoViewIndex()),0.0);
}
#else
{
l9_0=textureLod(renderTarget2,sc_SamplingCoordsViewToGlobal(uv,renderTarget2Layout,renderTarget2GetStereoViewIndex()).xy,0.0);
}
#endif
return l9_0;
}
int renderTarget3GetStereoViewIndex()
{
int l9_0;
#if (renderTarget3HasSwappedViews)
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
vec4 renderTarget3SampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (renderTarget3Layout==2)
{
l9_0=textureLod(renderTarget3ArrSC,sc_SamplingCoordsViewToGlobal(uv,renderTarget3Layout,renderTarget3GetStereoViewIndex()),0.0);
}
#else
{
l9_0=textureLod(renderTarget3,sc_SamplingCoordsViewToGlobal(uv,renderTarget3Layout,renderTarget3GetStereoViewIndex()).xy,0.0);
}
#endif
return l9_0;
}
float DecodeFloat32(vec4 rgba,bool Quantize)
{
if (Quantize)
{
rgba=floor((rgba*255.0)+vec4(0.5))/vec4(255.0);
}
return dot(rgba,vec4(1.0,0.0039215689,1.53787e-05,6.0308629e-08));
}
float DecodeFloat16(vec2 rg,bool Quantize)
{
if (Quantize)
{
rg=floor((rg*255.0)+vec2(0.5))/vec2(255.0);
}
return dot(rg,vec2(1.0,0.0039215689));
}
bool ssDecodeParticle(int InstanceID)
{
gParticle=ssParticle(vec3(0.0),vec3(0.0),vec4(0.0),0.0,0.0,0.0,1.0,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),gParticle.Dead,vec4(0.0,0.0,0.0,1.0),-1.0,-1.0,0.0,gParticle.SpawnOffset,gParticle.Seed,gParticle.Seed2000,gParticle.TimeShift,gParticle.Index1D,gParticle.Index1DPerCopy,gParticle.Index1DPerCopyF,gParticle.StateID,gParticle.Coord1D,gParticle.Ratio1D,gParticle.Ratio1DPerCopy,gParticle.Index2D,gParticle.Coord2D,gParticle.Ratio2D,gParticle.Force,gParticle.Spawned,float(InstanceID/15000),0.0,0.0,0.0);
int l9_0=InstanceID;
int l9_1=l9_0/15000;
int l9_2=l9_0%15000;
float l9_3=float(l9_2);
ivec2 l9_4=ivec2(l9_0%512,l9_0/512);
float l9_5=float(l9_0);
vec2 l9_6=vec2(l9_4);
float l9_7=l9_5/14999.0;
float l9_8=l9_7*15.0;
float l9_9;
if (overrideTimeEnabled==1)
{
l9_9=overrideTimeElapsed[l9_1];
}
else
{
l9_9=sc_Time.x;
}
gParticle=ssParticle(gParticle.Position,gParticle.Velocity,gParticle.Color,gParticle.Size,gParticle.Age,gParticle.Life,gParticle.Mass,gParticle.Matrix,false,gParticle.Quaternion,gParticle.SpawnIndex,gParticle.SpawnIndexRemainder,gParticle.NextBurstTime,l9_8,fract(abs(((l9_7*0.97637898)+0.151235)+(floor(((((l9_9-l9_8)-0.0)+0.0)+30.0)/15.0)*4.32723))),(vec2(ivec2(l9_0%400,l9_0/400))+vec2(1.0))/vec2(399.0),float(((l9_0*((l9_0*1471343)+101146501))+1559861749)&2147483647)*4.6566129e-10,l9_0,l9_2,l9_3,(15000*(l9_1+1))-1,(l9_5+0.5)/15000.0,l9_7,l9_3/14999.0,l9_4,(l9_6+vec2(0.5))/vec2(512.0,30.0),l9_6/vec2(511.0,29.0),vec3(0.0),false,gParticle.CopyId,gParticle.SpawnAmount,gParticle.BurstAmount,gParticle.BurstPeriod);
int l9_10=InstanceID;
int l9_11=(vfxOffsetInstancesRead+l9_10)*4;
int l9_12=l9_11/vfxTargetWidth;
vec2 l9_13=(vec2(ivec2(l9_11-(l9_12*vfxTargetWidth),l9_12))+vec2(0.5))/vec2(2048.0,vfxTargetSizeRead.y);
vec2 l9_14=l9_13+vec2(0.0);
vec4 l9_15=renderTarget0SampleViewBias(l9_14,0.0);
bool l9_16=dot(abs(l9_15),vec4(1.0))<9.9999997e-06;
bool l9_17;
if (!l9_16)
{
l9_17=!vfxBatchEnable[ssInstanceID/15000];
}
else
{
l9_17=l9_16;
}
if (l9_17)
{
return false;
}
float l9_18=1000.0-(-1000.0);
float l9_19=0.99998999-0.0;
gParticle.Position.x=(-1000.0)+(((DecodeFloat32(l9_15,true)-0.0)*l9_18)/l9_19);
gParticle.Position.y=(-1000.0)+(((DecodeFloat32(renderTarget1SampleViewBias(l9_14,0.0),true)-0.0)*l9_18)/l9_19);
gParticle.Position.z=(-1000.0)+(((DecodeFloat32(renderTarget2SampleViewBias(l9_14,0.0),true)-0.0)*l9_18)/l9_19);
gParticle.Velocity.x=(-1000.0)+(((DecodeFloat32(renderTarget3SampleViewBias(l9_14,0.0),true)-0.0)*l9_18)/l9_19);
vec2 l9_20=l9_13+vec2(0.00048828125,0.0);
gParticle.Velocity.y=(-1000.0)+(((DecodeFloat32(renderTarget0SampleViewBias(l9_20,0.0),true)-0.0)*l9_18)/l9_19);
gParticle.Velocity.z=(-1000.0)+(((DecodeFloat32(renderTarget1SampleViewBias(l9_20,0.0),true)-0.0)*l9_18)/l9_19);
float l9_21=15.0-0.0;
gParticle.Life=0.0+(((DecodeFloat32(renderTarget2SampleViewBias(l9_20,0.0),true)-0.0)*l9_21)/l9_19);
gParticle.Age=0.0+(((DecodeFloat32(renderTarget3SampleViewBias(l9_20,0.0),true)-0.0)*l9_21)/l9_19);
vec2 l9_22=l9_13+vec2(0.0009765625,0.0);
gParticle.Size=0.0+(((DecodeFloat32(renderTarget0SampleViewBias(l9_22,0.0),true)-0.0)*(100.0-0.0))/l9_19);
float l9_23=1.00001-0.0;
gParticle.Color.x=0.0+(((DecodeFloat32(renderTarget1SampleViewBias(l9_22,0.0),true)-0.0)*l9_23)/l9_19);
gParticle.Color.y=0.0+(((DecodeFloat32(renderTarget2SampleViewBias(l9_22,0.0),true)-0.0)*l9_23)/l9_19);
gParticle.Color.z=0.0+(((DecodeFloat32(renderTarget3SampleViewBias(l9_22,0.0),true)-0.0)*l9_23)/l9_19);
vec2 l9_24=l9_13+vec2(0.0014648438,0.0);
vec4 l9_25=renderTarget2SampleViewBias(l9_24,0.0);
vec4 l9_26=renderTarget3SampleViewBias(l9_24,0.0);
gParticle.Color.w=0.0+(((DecodeFloat32(renderTarget0SampleViewBias(l9_24,0.0),true)-0.0)*l9_23)/l9_19);
gParticle.Mass=0.0+(((DecodeFloat32(renderTarget1SampleViewBias(l9_24,0.0),true)-0.0)*(1000.0-0.0))/l9_19);
float l9_27=1.0-(-1.0);
gParticle.Quaternion.x=(-1.0)+(((DecodeFloat16(vec2(l9_25.xy),true)-0.0)*l9_27)/l9_19);
gParticle.Quaternion.y=(-1.0)+(((DecodeFloat16(vec2(l9_25.zw),true)-0.0)*l9_27)/l9_19);
gParticle.Quaternion.z=(-1.0)+(((DecodeFloat16(vec2(l9_26.xy),true)-0.0)*l9_27)/l9_19);
gParticle.Quaternion.w=(-1.0)+(((DecodeFloat16(vec2(l9_26.zw),true)-0.0)*l9_27)/l9_19);
vec4 l9_28=normalize(gParticle.Quaternion.yzwx);
float l9_29=l9_28.x;
float l9_30=l9_29*l9_29;
float l9_31=l9_28.y;
float l9_32=l9_31*l9_31;
float l9_33=l9_28.z;
float l9_34=l9_33*l9_33;
float l9_35=l9_29*l9_33;
float l9_36=l9_29*l9_31;
float l9_37=l9_31*l9_33;
float l9_38=l9_28.w;
float l9_39=l9_38*l9_29;
float l9_40=l9_38*l9_31;
float l9_41=l9_38*l9_33;
gParticle.Matrix=mat3(vec3(1.0-(2.0*(l9_32+l9_34)),2.0*(l9_36+l9_41),2.0*(l9_35-l9_40)),vec3(2.0*(l9_36-l9_41),1.0-(2.0*(l9_30+l9_34)),2.0*(l9_37+l9_39)),vec3(2.0*(l9_35+l9_40),2.0*(l9_37-l9_39),1.0-(2.0*(l9_30+l9_32))));
gParticle.Velocity=floor((gParticle.Velocity*2000.0)+vec3(0.5))*0.00050000002;
gParticle.Position=floor((gParticle.Position*2000.0)+vec3(0.5))*0.00050000002;
gParticle.Color=floor((gParticle.Color*2000.0)+vec4(0.5))*0.00050000002;
gParticle.Size=floor((gParticle.Size*2000.0)+0.5)*0.00050000002;
gParticle.Mass=floor((gParticle.Mass*2000.0)+0.5)*0.00050000002;
gParticle.Life=floor((gParticle.Life*2000.0)+0.5)*0.00050000002;
return true;
}
void Node169_Remap(float ValueIn,out float ValueOut,float RangeMinA,float RangeMaxA,float RangeMinB,float RangeMaxB,ssGlobals Globals)
{
ValueOut=(((ValueIn-RangeMinA)/((RangeMaxA-RangeMinA)+1e-06))*(RangeMaxB-RangeMinB))+RangeMinB;
float l9_0;
if (RangeMaxB>RangeMinB)
{
l9_0=clamp(ValueOut,RangeMinB,RangeMaxB);
}
else
{
l9_0=clamp(ValueOut,RangeMaxB,RangeMinB);
}
ValueOut=l9_0;
}
void main()
{
ssInstanceID=0;
ssInstanceID=sc_GetLocalInstanceIDInternal(sc_FallbackInstanceID);
int l9_0=ssInstanceID;
bool l9_1=l9_0>=(15000*(vfxNumCopies+1));
bool l9_2;
if (!l9_1)
{
l9_2=vfxBatchEnable[ssInstanceID/15000]==false;
}
else
{
l9_2=l9_1;
}
if (l9_2)
{
sc_SetClipPosition(vec4(4334.0,4334.0,4334.0,0.0));
return;
}
int l9_3=ssInstanceID;
bool l9_4=ssDecodeParticle(l9_3);
if (!l9_4)
{
sc_SetClipPosition(vec4(4334.0,4334.0,4334.0,0.0));
return;
}
float l9_5=min(overrideTimeDelta,0.5);
float l9_6=gParticle.TimeShift;
float l9_7=gParticle.Size;
bool l9_8=l9_7<9.9999997e-06;
bool l9_9;
if (!l9_8)
{
l9_9=gParticle.Age>=gParticle.Life;
}
else
{
l9_9=l9_8;
}
if (l9_9)
{
sc_SetClipPosition(vec4(4334.0,4334.0,4334.0,0.0));
return;
}
gParticle.Position=(vfxModelMatrix[ssInstanceID/15000]*vec4(gParticle.Position,1.0)).xyz;
int l9_10=ssInstanceID/15000;
gParticle.Velocity=mat3(vfxModelMatrix[l9_10][0].xyz,vfxModelMatrix[l9_10][1].xyz,vfxModelMatrix[l9_10][2].xyz)*gParticle.Velocity;
int l9_11=ssInstanceID/15000;
gParticle.Force=mat3(vfxModelMatrix[l9_11][0].xyz,vfxModelMatrix[l9_11][1].xyz,vfxModelMatrix[l9_11][2].xyz)*gParticle.Force;
int l9_12=ssInstanceID/15000;
gParticle.Matrix=mat3(vfxModelMatrix[l9_12][0].xyz,vfxModelMatrix[l9_12][1].xyz,vfxModelMatrix[l9_12][2].xyz)*gParticle.Matrix;
vec3 l9_13=gParticle.Position+(gParticle.Matrix*vec3(position.x*gParticle.Size,position.y*gParticle.Size,0.0));
varPosAndMotion=vec4(l9_13.x,l9_13.y,l9_13.z,varPosAndMotion.w);
vec3 l9_14=gParticle.Matrix*vec3(0.0,0.0,1.0);
varNormalAndMotion=vec4(l9_14.x,l9_14.y,l9_14.z,varNormalAndMotion.w);
vec3 l9_15=gParticle.Matrix*vec3(1.0,0.0,0.0);
varTangent=vec4(l9_15.x,l9_15.y,l9_15.z,varTangent.w);
varTangent.w=1.0;
varTex01=vec4(texture0,texture1);
vec3 l9_16=gParticle.Position;
float l9_17=gParticle.Size;
vec2 l9_18=texture0-vec2(Port_Input1_N037);
ssGlobals l9_19=ssGlobals(sc_Time.x,l9_5,(sc_Time.x-(l9_6*l9_5))-0.0,texture0,overrideTimeElapsed[ssInstanceID/15000]);
vec3 l9_20=gParticle.Velocity;
float l9_21;
Node169_Remap(gParticle.Size,l9_21,Port_RangeMinA_N169,Port_RangeMaxA_N169,Port_RangeMinB_N169,Port_RangeMaxB_N169,l9_19);
float l9_22=l9_21;
bool l9_23=(float(length(l9_20)<((Port_Value_N172+0.001)-0.001))*1.0)!=0.0;
bool l9_24;
if (!l9_23)
{
l9_24=(float(l9_22<Port_Input1_N093)*1.0)!=0.0;
}
else
{
l9_24=l9_23;
}
vec3 l9_25;
if ((float(l9_24)*1.0)!=0.0)
{
l9_25=Port_Input1_N181;
}
else
{
vec3 l9_26=gParticle.Velocity;
float l9_27=dot(l9_26,l9_26);
float l9_28;
if (l9_27>0.0)
{
l9_28=1.0/sqrt(l9_27);
}
else
{
l9_28=0.0;
}
l9_25=l9_26*l9_28;
}
vec3 l9_29=gParticle.Position;
vec3 l9_30=sc_Camera.position-l9_29;
float l9_31=dot(l9_30,l9_30);
float l9_32;
if (l9_31>0.0)
{
l9_32=1.0/sqrt(l9_31);
}
else
{
l9_32=0.0;
}
vec3 l9_33=l9_30*l9_32;
vec3 l9_34=cross(l9_25,l9_33);
float l9_35=dot(l9_34,l9_34);
float l9_36;
if (l9_35>0.0)
{
l9_36=1.0/sqrt(l9_35);
}
else
{
l9_36=0.0;
}
vec3 l9_37=l9_34*l9_36;
vec3 l9_38=vec3(l9_17);
float param_5;
Node169_Remap(gParticle.Size,param_5,Port_RangeMinA_N169,Port_RangeMaxA_N169,Port_RangeMinB_N169,Port_RangeMaxB_N169,l9_19);
vec3 l9_39=(l9_16+((l9_38*vec3(l9_18.x))*l9_37))+(((l9_38*vec3(l9_18.y))*vec3(max(length(gParticle.Velocity)*param_5,Port_Input1_N171)))*l9_25);
varPosAndMotion=vec4(l9_39.x,l9_39.y,l9_39.z,varPosAndMotion.w);
varTangent=vec4(l9_25.x,l9_25.y,l9_25.z,varTangent.w);
vec3 l9_40=cross(l9_25,l9_37);
float l9_41=dot(l9_40,l9_40);
float l9_42;
if (l9_41>0.0)
{
l9_42=1.0/sqrt(l9_41);
}
else
{
l9_42=0.0;
}
vec3 l9_43=l9_40*l9_42;
varNormalAndMotion=vec4(l9_43.x,l9_43.y,l9_43.z,varNormalAndMotion.w);
vec4 l9_44=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
vec4 l9_45;
#if (sc_DepthBufferMode==1)
{
vec4 l9_46;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
float l9_47=l9_44.w;
vec4 l9_48=l9_44;
l9_48.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_47))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_47;
l9_46=l9_48;
}
else
{
l9_46=l9_44;
}
l9_45=l9_46;
}
#else
{
l9_45=l9_44;
}
#endif
sc_SetClipPosition(l9_45);
Interp_Particle_Index=ssInstanceID;
Interp_Particle_Force=gParticle.Force;
Interp_Particle_Position=gParticle.Position;
Interp_Particle_Velocity=gParticle.Velocity;
Interp_Particle_Life=gParticle.Life;
Interp_Particle_Age=gParticle.Age;
Interp_Particle_Size=gParticle.Size;
Interp_Particle_Color=gParticle.Color;
Interp_Particle_Quaternion=gParticle.Quaternion;
Interp_Particle_Mass=gParticle.Mass;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
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
#ifndef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 0
#elif sc_BlendMode_PremultipliedAlphaAuto==1
#undef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 1
#endif
#ifndef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 0
#elif sc_BlendMode_MultiplyOriginal==1
#undef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 1
#endif
#ifndef sc_BlendMode_Screen
#define sc_BlendMode_Screen 0
#elif sc_BlendMode_Screen==1
#undef sc_BlendMode_Screen
#define sc_BlendMode_Screen 1
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
#ifndef renderTarget0HasSwappedViews
#define renderTarget0HasSwappedViews 0
#elif renderTarget0HasSwappedViews==1
#undef renderTarget0HasSwappedViews
#define renderTarget0HasSwappedViews 1
#endif
#ifndef renderTarget0Layout
#define renderTarget0Layout 0
#endif
#ifndef renderTarget1HasSwappedViews
#define renderTarget1HasSwappedViews 0
#elif renderTarget1HasSwappedViews==1
#undef renderTarget1HasSwappedViews
#define renderTarget1HasSwappedViews 1
#endif
#ifndef renderTarget1Layout
#define renderTarget1Layout 0
#endif
#ifndef renderTarget2HasSwappedViews
#define renderTarget2HasSwappedViews 0
#elif renderTarget2HasSwappedViews==1
#undef renderTarget2HasSwappedViews
#define renderTarget2HasSwappedViews 1
#endif
#ifndef renderTarget2Layout
#define renderTarget2Layout 0
#endif
#ifndef renderTarget3HasSwappedViews
#define renderTarget3HasSwappedViews 0
#elif renderTarget3HasSwappedViews==1
#undef renderTarget3HasSwappedViews
#define renderTarget3HasSwappedViews 1
#endif
#ifndef renderTarget3Layout
#define renderTarget3Layout 0
#endif
uniform vec4 sc_CurrentRenderTargetDims;
uniform vec4 sc_UniformConstants;
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform vec2 Port_Input1_N137;
uniform float Port_Input1_N138;
uniform float Port_Import_N140;
uniform float Port_Import_N142;
uniform float Port_Input1_N144;
uniform float Port_Input2_N144;
uniform sampler2D sc_ScreenTexture;
uniform sampler2DArray sc_ScreenTextureArrSC;
uniform sampler2D intensityTexture;
uniform sampler2DArray intensityTextureArrSC;
flat in int varStereoViewID;
in float varClipDistance;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#define out inout
#endif
layout(location=0) out vec4 sc_FragData0;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#undef out
#endif
in vec4 varScreenPos;
in vec4 varTex01;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec3 Interp_Particle_Position;
in vec3 Interp_Particle_Velocity;
in float Interp_Particle_Life;
in float Interp_Particle_Age;
in float Interp_Particle_Size;
in vec4 Interp_Particle_Color;
in vec4 Interp_Particle_Quaternion;
in float Interp_Particle_Mass;
flat in int Interp_Particle_Index;
in vec4 varPosAndMotion;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
in vec4 varColor;
in vec3 Interp_Particle_Force;
in vec2 Interp_Particle_Coord;
in float Interp_Particle_SpawnIndex;
in float Interp_Particle_NextBurstTime;
in float gParticlesDebug;
in vec2 ParticleUV;
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
int renderTarget0GetStereoViewIndex()
{
int l9_0;
#if (renderTarget0HasSwappedViews)
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
int renderTarget1GetStereoViewIndex()
{
int l9_0;
#if (renderTarget1HasSwappedViews)
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
int renderTarget2GetStereoViewIndex()
{
int l9_0;
#if (renderTarget2HasSwappedViews)
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
int renderTarget3GetStereoViewIndex()
{
int l9_0;
#if (renderTarget3HasSwappedViews)
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
void main()
{
#if (sc_MotionVectorsPass)
{
discard;
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
#if (renderTarget0Layout==2)
{
}
#else
{
}
#endif
#if (renderTarget1Layout==2)
{
}
#else
{
}
#endif
#if (renderTarget2Layout==2)
{
}
#else
{
}
#endif
#if (renderTarget3Layout==2)
{
}
#else
{
}
#endif
float l9_0=1.0-(distance(varTex01.xy,Port_Input1_N137)*Port_Input1_N138);
float l9_1;
if (l9_0<=0.0)
{
l9_1=0.0;
}
else
{
l9_1=pow(l9_0,Port_Import_N140);
}
float l9_2=l9_1*Port_Import_N142;
float l9_3=clamp(l9_2+0.001,Port_Input1_N144+0.001,Port_Input2_N144+0.001)-0.001;
vec4 l9_4=vec4(Interp_Particle_Color.x,Interp_Particle_Color.y,Interp_Particle_Color.z,vec4(0.0).w);
l9_4.w=l9_3;
vec4 l9_5;
#if (sc_RenderAlphaToColor)
{
l9_5=vec4(l9_3);
}
#else
{
vec4 l9_6;
#if (sc_BlendMode_Custom)
{
vec4 l9_7;
#if (sc_FramebufferFetch)
{
l9_7=sc_readFragData0();
}
#else
{
vec2 l9_8=gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw;
vec2 l9_9;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_10=vec3(l9_8,0.0);
l9_10.y=((2.0*l9_8.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_9=l9_10.xy;
}
#else
{
l9_9=l9_8;
}
#endif
vec4 l9_11;
#if (sc_ScreenTextureLayout==2)
{
l9_11=texture(sc_ScreenTextureArrSC,sc_SamplingCoordsViewToGlobal(l9_9,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()),0.0);
}
#else
{
l9_11=texture(sc_ScreenTexture,sc_SamplingCoordsViewToGlobal(l9_9,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()).xy,0.0);
}
#endif
l9_7=l9_11;
}
#endif
vec3 l9_12=mix(l9_7.xyz,definedBlend(l9_7.xyz,l9_4.xyz).xyz,vec3(l9_3));
vec4 l9_13=vec4(l9_12.x,l9_12.y,l9_12.z,vec4(0.0).w);
l9_13.w=1.0;
l9_6=l9_13;
}
#else
{
vec4 l9_14;
#if (sc_Voxelization)
{
l9_14=vec4(varScreenPos.xyz,1.0);
}
#else
{
vec4 l9_15;
#if (sc_OutputBounds)
{
float l9_16=clamp(abs(gl_FragCoord.z),0.0,1.0);
l9_15=vec4(l9_16,1.0-l9_16,1.0,1.0);
}
#else
{
vec4 l9_17;
#if (sc_BlendMode_MultiplyOriginal)
{
l9_17=vec4(mix(vec3(1.0),l9_4.xyz,vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_18;
#if (sc_BlendMode_Screen||sc_BlendMode_PremultipliedAlphaAuto)
{
float l9_19;
#if (sc_BlendMode_PremultipliedAlphaAuto)
{
l9_19=clamp(l9_3,0.0,1.0);
}
#else
{
l9_19=l9_3;
}
#endif
l9_18=vec4(l9_4.xyz*l9_19,l9_19);
}
#else
{
l9_18=l9_4;
}
#endif
l9_17=l9_18;
}
#endif
l9_15=l9_17;
}
#endif
l9_14=l9_15;
}
#endif
l9_6=l9_14;
}
#endif
l9_5=l9_6;
}
#endif
vec4 l9_20;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_21=l9_5;
l9_21.x=l9_5.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_20=l9_21;
}
#else
{
l9_20=l9_5;
}
#endif
sc_FragData0=l9_20;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
