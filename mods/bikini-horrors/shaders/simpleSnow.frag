#pragma header

uniform float time;
uniform vec2 res;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 col = flixel_texture2D(bitmap, uv);

    // screen-space coords
    vec2 p = gl_FragCoord.xy / res;

    float snow = 0.0;

    // number of flakes
    for (int i = 0; i < 40; i++) {
        float fi = float(i);
        vec2 pos = vec2(
            rand(vec2(fi, 0.1)),
            fract(rand(vec2(fi, 0.7)) + time * (0.05 + fi * 0.002))
        );

        float d = distance(p, pos);
        snow += smoothstep(0.03, 0.0, d);
    }

    col.rgb += vec3(snow);
    gl_FragColor = col;
}
