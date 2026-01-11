/*
--------------------------------------------------------------------------------

  Photon Shader by SixthSurge

  program/c3_taau_prep:
  Calculate neighborhood limits for TAAU

--------------------------------------------------------------------------------
*/

#include "/include/global.glsl"

layout(location = 0) out float depthOutput;

/* RENDERTARGETS: 17 */

in vec2 uv;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform float frameTime;
uniform float near;
uniform float far;

uniform vec2 view_res;
uniform vec2 view_pixel_size;

#define TEMPORAL_REPROJECTION
#include "/include/utility/color.glsl"
#include "/include/utility/space_conversion.glsl"
void main() {
}

#endif
//----------------------------------------------------------------------------//
