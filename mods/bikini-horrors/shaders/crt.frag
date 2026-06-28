#pragma header

uniform float curvature;
uniform float scanlines;
uniform float rgbShift;
uniform float blur;

vec2 curveUV(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    uv *= 1.0 + abs(uv.yx) * abs(uv.yx) * curvature;
    return uv * 0.5 + 0.5;
}

float scanline(vec2 uv) {
    return sin(uv.y * openfl_TextureSize.y * 3.14159265);
}

vec3 rgbMask(vec2 uv) {
    float px = mod(floor(uv.x * openfl_TextureSize.x), 3.0);
    vec3 mask = vec3(0.6);

    mask.r = step(px, 0.5);
    mask.g = step(0.5, px) * step(px, 1.5);
    mask.b = step(1.5, px);

    return max(mask, vec3(0.6));
}

void main() {
    vec2 curvedUV = openfl_TextureCoordv;
    if (curvature > 0.001)
        curvedUV = curveUV(openfl_TextureCoordv);

    // Mask: 1.0 = inside screen, 0.0 = outside
    float edge = 0.02;
    float inside =
        smoothstep(0.0, edge, curvedUV.x) *
        smoothstep(0.0, edge, curvedUV.y) *
        smoothstep(1.0, 1.0 - edge, curvedUV.x) *
        smoothstep(1.0, 1.0 - edge, curvedUV.y);


    // Use unclamped UV for masking, clamped UV for sampling
    vec2 uv = clamp(curvedUV, 0.0, 1.0);

    vec2 texel = 1.0 / openfl_TextureSize.xy;
    vec4 base = flixel_texture2D(bitmap, uv);

    vec3 col = base.rgb;
    if (rgbShift > 0.001) {
        col.r = flixel_texture2D(bitmap, uv + vec2(texel.x * rgbShift, 0.0)).r;
        col.g = base.g;
        col.b = flixel_texture2D(bitmap, uv - vec2(texel.x * rgbShift, 0.0)).b;
    }

    if (blur > 0.001) {
        vec3 blurCol =
            flixel_texture2D(bitmap, uv + texel * blur).rgb +
            flixel_texture2D(bitmap, uv - texel * blur).rgb;
        col = mix(col, blurCol * 0.5, blur);
    }

    if (scanlines > 0.001) {
        float sl = scanline(uv);
        col *= mix(1.0, 0.85 + 0.15 * sl, scanlines);
    }

    if (rgbShift > 0.001)
        col *= mix(vec3(1.0), rgbMask(uv), rgbShift);

    // Apply black border
    col *= inside;

    // Alpha-safe output (important for camHUD)
    gl_FragColor = vec4(col, base.a * inside);
}
