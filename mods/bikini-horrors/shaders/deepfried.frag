#pragma header

uniform float strength; // 0.0 -> 1.0
uniform float darkness; // 0.0 -> 1.0
uniform float distort;  // 0.0 -> 0.03

void main()
{
    vec2 uv = openfl_TextureCoordv;
    if (strength <= 0.001 && darkness <= 0.001 && distort <= 0.001) {
        gl_FragColor = flixel_texture2D(bitmap, uv);
        return;
    }

    // -----------------------------
    // Barrel distortion
    // -----------------------------
    vec2 p = uv * 2.0 - 1.0;

    float r = dot(p, p);

    p *= 1.0 + (r * distort);

    vec2 warpedUV = (p + 1.0) / 2.0;

    // -----------------------------
    // Chromatic aberration
    // -----------------------------
    vec2 aberration = vec2(0.003 * strength);

    vec4 tex = flixel_texture2D(bitmap, warpedUV);
    float red = flixel_texture2D(bitmap, warpedUV + aberration).r;
    float green = tex.g;
    float blue = flixel_texture2D(bitmap, warpedUV - aberration).b;

    vec3 color = vec3(red, green, blue);

    // -----------------------------
    // Saturation boost
    // -----------------------------
    float gray = dot(color, vec3(0.299, 0.587, 0.114));

    color = mix(vec3(gray), color, 1.0 + strength * 2.5);

    // -----------------------------
    // Contrast crush
    // -----------------------------
    color = (color - 0.5) * (1.0 + strength * 3.0) + 0.5;

    // -----------------------------
    // Red shadow tint
    // -----------------------------
    color.r += strength * 0.15;
    color.gb -= strength * 0.05;

    // -----------------------------
    // Darkness
    // -----------------------------
    color *= (1.0 - darkness);

    // -----------------------------
    // Vignette
    // -----------------------------
    float vignette = 1.0;

    if (strength > 0.001)
    {
        vignette = mix(1.0, smoothstep(1.2, 0.2, length(p)), strength);
    }

    color *= vignette;

    gl_FragColor = vec4(color, tex.a);
}
