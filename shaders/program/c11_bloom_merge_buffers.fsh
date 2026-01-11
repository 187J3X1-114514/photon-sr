/*
--------------------------------------------------------------------------------

  Photon Shader by SixthSurge

  program/c11_bloom_merge_buffers:
  Copy bloom tiles from read buffer to write buffer

--------------------------------------------------------------------------------
*/

#include "/include/global.glsl"

layout (location = 0) out vec3 bloom_tiles;

#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
/* RENDERTARGETS: 18 */
#else
/* RENDERTARGETS: 0 */
#endif

in vec2 uv;

#if defined(SR_INSTALLED) && defined(SR_SHOULD_APPLY_SCALE) && (SR_SHOULD_APPLY_SCALE == 1)
uniform sampler2D colortex18; // Bloom tiles (full res for SR)
#define BLOOM_TILES_TEX colortex18
#else
uniform sampler2D colortex0;  // Bloom tiles (render scale)
#define BLOOM_TILES_TEX colortex0
#endif

uniform vec2 view_res;


void main() {
	int tile_index = int(-log2(1.0 - uv.x));

	if ((tile_index & 1) == 1) {
		bloom_tiles = texelFetch(BLOOM_TILES_TEX, ivec2(gl_FragCoord.xy), 0).rgb;
	} else {
		discard;
	}
}

