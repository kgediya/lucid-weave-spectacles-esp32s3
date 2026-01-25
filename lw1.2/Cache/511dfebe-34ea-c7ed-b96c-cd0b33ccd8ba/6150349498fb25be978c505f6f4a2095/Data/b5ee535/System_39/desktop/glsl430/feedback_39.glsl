#version 430
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
// SCC_BACKEND_SHADER_FLAGS_BEGIN__
// SCC_BACKEND_SHADER_FLAG_DISABLE_FRUSTUM_CULLING
// SCC_BACKEND_SHADER_FLAGS_END__
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec4 boneData 5
//attribute vec3 blendShape0Pos 6
//attribute vec3 blendShape1Pos 7
//attribute vec3 blendShape2Pos 8
//attribute vec3 blendShape3Pos 9
//attribute vec3 blendShape4Pos 10
//attribute vec3 blendShape5Pos 11
//attribute vec3 blendShape0Normal 12
//attribute vec3 blendShape1Normal 13
//attribute vec3 blendShape2Normal 14
//attribute vec3 positionNext 15
//attribute vec3 positionPrevious 16
//attribute vec4 strandProperties 17
//output vec4 sc_FragData0 0
//output vec4 sc_FragData1 1
//output vec4 sc_FragData2 2
//output vec4 sc_FragData3 3
//sampler sampler renderTarget0SmpSC 0:10
//sampler sampler renderTarget1SmpSC 0:11
//sampler sampler renderTarget2SmpSC 0:12
//sampler sampler renderTarget3SmpSC 0:13
//texture texture2D renderTarget0 0:0:0:10
//texture texture2D renderTarget1 0:1:0:11
//texture texture2D renderTarget2 0:2:0:12
//texture texture2D renderTarget3 0:3:0:13
//texture texture2DArray renderTarget0ArrSC 0:20:0:10
//texture texture2DArray renderTarget1ArrSC 0:21:0:11
//texture texture2DArray renderTarget2ArrSC 0:22:0:12
//texture texture2DArray renderTarget3ArrSC 0:23:0:13
//spec_const bool renderTarget0HasSwappedViews 0 0
//spec_const bool renderTarget1HasSwappedViews 1 0
//spec_const bool renderTarget2HasSwappedViews 2 0
//spec_const bool renderTarget3HasSwappedViews 3 0
//spec_const int renderTarget0Layout 4 0
//spec_const int renderTarget1Layout 5 0
//spec_const int renderTarget2Layout 6 0
//spec_const int renderTarget3Layout 7 0
//spec_const int sc_ShaderCacheConstant 8 0
//spec_const int sc_StereoRenderingMode 9 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 10 0
//spec_const int sc_StereoViewID 11 0
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
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
out vec4 varTex01;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out vec4 varTangent;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out float varViewSpaceDepth;
out vec2 varShadowTex;
in vec4 boneData;
in vec3 blendShape0Pos;
in vec3 blendShape1Pos;
in vec3 blendShape2Pos;
in vec3 blendShape3Pos;
in vec3 blendShape4Pos;
in vec3 blendShape5Pos;
in vec3 blendShape0Normal;
in vec3 blendShape1Normal;
in vec3 blendShape2Normal;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
vec2 l9_0=(texture0*2.0)-vec2(1.0);
float l9_1=l9_0.x;
vec4 l9_2=vec4(l9_1,l9_0.y,1.0,1.0);
vec4 l9_3;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_4=l9_2;
l9_4.x=l9_1+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_3=l9_4;
}
#else
{
l9_3=l9_2;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_5=dot(l9_3,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_5);
}
#else
{
varClipDistance=l9_5;
}
#endif
}
#endif
gl_Position=l9_3;
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
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
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
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
uniform vec4 sc_UniformConstants;
uniform sampler2DArray renderTarget0ArrSC;
uniform sampler2D renderTarget0;
uniform sampler2DArray renderTarget1ArrSC;
uniform sampler2D renderTarget1;
uniform sampler2DArray renderTarget2ArrSC;
uniform sampler2D renderTarget2;
uniform sampler2DArray renderTarget3ArrSC;
uniform sampler2D renderTarget3;
flat in int varStereoViewID;
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
layout(location=1) out vec4 sc_FragData1;
layout(location=2) out vec4 sc_FragData2;
layout(location=3) out vec4 sc_FragData3;
in vec4 varTex01;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in float varViewSpaceDepth;
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
void main()
{
#if ((sc_StereoRenderingMode==1)&&(sc_StereoRendering_IsClipDistanceEnabled==0))
{
if (varClipDistance<0.0)
{
discard;
}
}
#endif
vec4 l9_0;
#if (renderTarget0Layout==2)
{
l9_0=texture(renderTarget0ArrSC,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget0Layout,renderTarget0GetStereoViewIndex()),0.0);
}
#else
{
l9_0=texture(renderTarget0,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget0Layout,renderTarget0GetStereoViewIndex()).xy,0.0);
}
#endif
vec4 l9_1;
#if (renderTarget1Layout==2)
{
l9_1=texture(renderTarget1ArrSC,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget1Layout,renderTarget1GetStereoViewIndex()),0.0);
}
#else
{
l9_1=texture(renderTarget1,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget1Layout,renderTarget1GetStereoViewIndex()).xy,0.0);
}
#endif
vec4 l9_2;
#if (renderTarget2Layout==2)
{
l9_2=texture(renderTarget2ArrSC,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget2Layout,renderTarget2GetStereoViewIndex()),0.0);
}
#else
{
l9_2=texture(renderTarget2,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget2Layout,renderTarget2GetStereoViewIndex()).xy,0.0);
}
#endif
vec4 l9_3;
#if (renderTarget3Layout==2)
{
l9_3=texture(renderTarget3ArrSC,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget3Layout,renderTarget3GetStereoViewIndex()),0.0);
}
#else
{
l9_3=texture(renderTarget3,sc_SamplingCoordsViewToGlobal(varTex01.xy,renderTarget3Layout,renderTarget3GetStereoViewIndex()).xy,0.0);
}
#endif
if (dot(((l9_0+l9_1)+l9_2)+l9_3,vec4(0.2542325))==(-1231456.8))
{
discard;
}
vec4 l9_4;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_5=l9_0;
l9_5.x=l9_0.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_4=l9_5;
}
#else
{
l9_4=l9_0;
}
#endif
sc_FragData0=l9_4;
sc_FragData1=l9_1;
sc_FragData2=l9_2;
sc_FragData3=l9_3;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
