/*
--------------------------------------------------------------------------------

  Photon Shader by SixthSurge

  program/c16_motion_blur:
  Apply motion blur

--------------------------------------------------------------------------------
*/

#include "/include/global.glsl"

layout (location = 0) out vec3 scene_color;

#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
/* RENDERTARGETS: 18 */
#else
/* RENDERTARGETS: 0 */
#endif

in vec2 uv;

// ------------
//   Uniforms
// ------------

#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
uniform sampler2D colortex18; // Scene color (full res for SR)
#define SCENE_COLOR_TEX colortex18
#else
uniform sampler2D colortex0; // Scene color
#define SCENE_COLOR_TEX colortex0
#endif

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
#include "/include/utility/space_conversion.glsl"

#define MOTION_BLUR_SAMPLES 20

void main() {
	ivec2 texel      = ivec2(gl_FragCoord.xy);
	ivec2 view_texel = ivec2(gl_FragCoord.xy * taau_render_scale);

	float depth = texelFetch(depthtex0, view_texel, 0).x;

	if (depth < hand_depth) {
		scene_color = texelFetch(SCENE_COLOR_TEX, texel, 0).rgb;
		return;
	}

	vec2 velocity = uv - reproject(vec3(uv, depth)).xy;;
	vec2 pos = uv;
	vec2 increment = (0.5 * MOTION_BLUR_INTENSITY / float(MOTION_BLUR_SAMPLES)) * velocity;

	vec3 color_sum = vec3(0.0);
	float weight_sum = 0.0;

	for (uint i = 0u; i < MOTION_BLUR_SAMPLES; ++i, pos += increment) {
		ivec2 tap      = ivec2(pos * view_res);
		ivec2 view_tap = ivec2(pos * view_res * taau_render_scale);

		vec3 color = texelFetch(SCENE_COLOR_TEX, tap, 0).rgb;
		float depth = texelFetch(depthtex0, view_tap, 0).x;
		float weight = (clamp01(pos) == pos && depth > hand_depth) ? 1.0 : 0.0;

		color_sum += color * weight;
		weight_sum += weight;
	}

	scene_color = color_sum * rcp(weight_sum);
}

