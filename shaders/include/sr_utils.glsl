//  Copyright © 2026 187J3X1-114514
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files(the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and /or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions :
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#ifdef SR_INSTALLED
    #ifdef SR_UTILS_SHOULD_ADD_UNIFORMS
        uniform float SRRatio;
        uniform float SRRenderScale;
        uniform float SRRenderScaleLog2;
        uniform vec2 SRScaledViewportSize;
        uniform vec2 SROriginalViewportSize;
        uniform ivec2 SRScaledViewportSizeI;
        uniform ivec2 SROriginalViewportSizeI;
        uniform vec2 SRJitterOffset;
    #endif // SR_UTILS_SHOULD_ADD_UNIFORMS
    #define MC_RENDER_SCALE (SRRenderScale)
    #define MC_RENDER_RATIO (SRRatio)
    #define MC_RENDER_SCALE_LOG2 (SRRenderScaleLog2)
    #define MC_SCALED_VIEWPORT_SIZE (SRScaledViewportSize)
    #define MC_ORIGINAL_VIEWPORT_SIZE (SROriginalViewportSize)
    #define MC_SCALED_VIEWPORT_SIZEI (SRScaledViewportSizeI)
    #define MC_ORIGINAL_VIEWPORT_SIZEI (SROriginalViewportSizeI)
    #if (SR_ALGO_SUPPORTS_JITTER == 1) && (SR_SHOULD_APPLY_JITTER == 1)
        #define MC_JITTER_OFFSET (SRJitterOffset)
    #else
        #define MC_JITTER_OFFSET (vec2(0.0))
    #endif //(SR_ALGO_SUPPORTS_JITTER == 1) && (SR_SHOULD_APPLY_JITTER == 1)
#else
    #define MC_RENDER_SCALE (1.0)
    #define MC_RENDER_RATIO (1.0)
    #define MC_RENDER_SCALE_LOG2 (0.0)
    #define MC_SCALED_VIEWPORT_SIZE (vec2(viewWidth, viewHeight))
    #define MC_ORIGINAL_VIEWPORT_SIZE (vec2(viewWidth, viewHeight))
    #define MC_SCALED_VIEWPORT_SIZEI (ivec2(viewWidth, viewHeight))
    #define MC_ORIGINAL_VIEWPORT_SIZEI (ivec2(viewWidth, viewHeight))
    #define MC_JITTER_OFFSET (vec2(0.0))
#endif // SR_INSTALLED

#ifdef SR_UTILS_SHOULD_ADD_FUNCTIONS

    float get_render_scale() {
        return MC_RENDER_SCALE;
    }

    float get_render_ratio() {
        return MC_RENDER_RATIO;
    }

    float get_render_scale_log2() {
        return MC_RENDER_SCALE_LOG2;
    }

    vec2 get_scaled_viewport_size() {
        return MC_SCALED_VIEWPORT_SIZE;
    }

    vec2 get_original_viewport_size() {
        return MC_ORIGINAL_VIEWPORT_SIZE;
    }

    ivec2 get_scaled_viewport_sizei() {
        return MC_SCALED_VIEWPORT_SIZEI;
    }

    ivec2 get_original_viewport_sizei() {
        return MC_ORIGINAL_VIEWPORT_SIZEI;
    }

    vec2 get_jitter_offset() {
        return MC_JITTER_OFFSET;
    }

    bool is_sr_installed() {
        #ifdef SR_INSTALLED
        return true;
        #else
        return false;
        #endif
    }

    bool should_apply_jitter() {
        #if defined(SR_INSTALLED) && (SR_ALGO_SUPPORTS_JITTER == 1) && (SR_SHOULD_APPLY_JITTER == 1)
        return true;
        #else
        return false;
        #endif
    }

    bool algo_supports_jitter() {
        #if defined(SR_INSTALLED) && (SR_ALGO_SUPPORTS_JITTER == 1)
        return true;
        #else
        return false;
        #endif
    }

    bool should_apply_scale() {
        #if defined(SR_INSTALLED) && (SR_SHOULD_APPLY_SCALE == 1)
        return true;
        #else
        return false;
        #endif
    }
#endif // SR_UTILS_SHOULD_ADD_FUNCTIONS