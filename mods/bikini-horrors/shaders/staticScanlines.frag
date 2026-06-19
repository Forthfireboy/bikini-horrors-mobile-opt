#pragma header

uniform float scanlines;
uniform float staticAmount;
uniform float staticScale;
uniform float staticSpeed;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 base = flixel_texture2D(bitmap, uv);

    float scale = max(staticScale, 1.0);
    float t = time * max(staticSpeed, 0.0);
    vec2 noiseUv = uv * openfl_TextureSize.xy / scale;
    float n = hash(noiseUv + vec2(t, t * 1.37));
    float grain = (n - 0.5) * 2.0;

    vec3 col = base.rgb;
    col += grain * 0.15 * clamp(staticAmount, 0.0, 1.0);

    float sl = sin(uv.y * openfl_TextureSize.y * 3.14159265);
    col *= mix(1.0, 0.85 + 0.15 * sl, scanlines);

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), base.a);
}
