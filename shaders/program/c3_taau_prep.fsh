/*
--------------------------------------------------------------------------------

  Photon Shader by SixthSurge

  program/c3_taau_prep:
  Calculate neighborhood limits for TAAU

--------------------------------------------------------------------------------
*/

#include "/include/global.glsl"

layout(location = 0) out vec2 mv;

/* RENDERTARGETS: 1 */

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
uniform vec2 taa_offset;
#define TEMPORAL_REPROJECTION
#include "/include/utility/color.glsl"
#include "/include/utility/space_conversion.glsl"
vec2 compute_velocity(vec2 uv, float depth) {
    vec3 closest = vec3(uv, depth);
    vec3 view_pos  = screen_to_view_space(closest, false, false);
    vec3 scene_pos = view_to_scene_space(view_pos);
    vec2 velocity  = closest.xy - reproject_scene_space(scene_pos, false, false).xy;
    return velocity;
}


void main() {
    ivec2 texel = ivec2(gl_FragCoord.xy);
	mv = compute_velocity(uv, texelFetch(depthtex0, texel, 0).x);
}

#endif
//----------------------------------------------------------------------------//
