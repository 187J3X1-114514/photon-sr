/*
--------------------------------------------------------------------------------

  Photon Shader by SixthSurge

  program/c5_c10_bloom_downsample
  Progressively downsample bloom tiles
  You must define BLOOM_TILE_INDEX before including this file

--------------------------------------------------------------------------------
*/

#include "/include/global.glsl"

#define bloom_tile_scale(i) 0.5 * exp2(-(i))
#define bloom_tile_offset(i) vec2(            \
	1.0 - exp2(-(i)),                       \
	float((i) & 1) * (1.0 - 0.5 * exp2(-(i))) \
)

layout (location = 0) out vec3 bloom_tile;

#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
/* RENDERTARGETS: 18 */
#else
/* RENDERTARGETS: 0 */
#endif

in vec2 uv;

uniform vec2 view_pixel_size;


const float tile_scale = bloom_tile_scale(BLOOM_TILE_INDEX);
const vec2 tile_offset = bloom_tile_offset(BLOOM_TILE_INDEX);

#if BLOOM_TILE_INDEX == 0
	// Initial tile reads TAA output directly
	const float src_tile_scale = 1.0;
	const vec2 src_tile_offset = vec2(0.0);
	#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
	uniform sampler2D colortex19; // Scene history (full resolution for SR)
	#define SRC_SAMPLER colortex19
	#else
	uniform sampler2D colortex5; // Scene history (render scale)
	#define SRC_SAMPLER colortex5
	#endif
#else
	// Subsequent tiles read from the previous bloom tile
	const float src_tile_scale = bloom_tile_scale(BLOOM_TILE_INDEX - 1);
	const vec2 src_tile_offset = bloom_tile_offset(BLOOM_TILE_INDEX - 1);
	#if defined(TAAU) && !(defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1))
	uniform sampler2D colortex0;  // Bloom tiles (render scale)
	#define SRC_SAMPLER colortex0
	#else
	uniform sampler2D colortex18; // Bloom tiles (upscaled / SR path)
	#define SRC_SAMPLER colortex18
	#endif
#endif

void main() {
	vec2 pad_amount = 3.0 * view_pixel_size * rcp(src_tile_scale);
	vec2 uv_src = clamp(uv, pad_amount, 1.0 - pad_amount) * src_tile_scale + src_tile_offset;

	// 6x6 downsampling filter made from overlapping 4x4 box kernels
	// As described in "Next Generation Post-Processing in Call of Duty Advanced Warfare"
	bloom_tile  = textureLod(SRC_SAMPLER, uv_src + vec2( 0.0,  0.0) * view_pixel_size, 0).rgb * 0.125;

	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 1.0,  1.0) * view_pixel_size, 0).rgb * 0.125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2(-1.0,  1.0) * view_pixel_size, 0).rgb * 0.125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 1.0, -1.0) * view_pixel_size, 0).rgb * 0.125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2(-1.0, -1.0) * view_pixel_size, 0).rgb * 0.125;

	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 2.0,  0.0) * view_pixel_size, 0).rgb * 0.0625;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2(-2.0,  0.0) * view_pixel_size, 0).rgb * 0.0625;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 0.0,  2.0) * view_pixel_size, 0).rgb * 0.0625;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 0.0, -2.0) * view_pixel_size, 0).rgb * 0.0625;

	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 2.0,  2.0) * view_pixel_size, 0).rgb * 0.03125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2(-2.0,  2.0) * view_pixel_size, 0).rgb * 0.03125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2( 2.0, -2.0) * view_pixel_size, 0).rgb * 0.03125;
	bloom_tile += textureLod(SRC_SAMPLER, uv_src + vec2(-2.0, -2.0) * view_pixel_size, 0).rgb * 0.03125;
}

