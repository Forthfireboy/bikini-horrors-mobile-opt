#pragma header

uniform float u_time;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 p = uv * 2.0 - 1.0;

    float t = u_time * 1.5;

    p.x += sin(p.y * 5.0 + t) * 0.15;
    p.y += cos(p.x * 4.0 + t * 1.3) * 0.15;

    float wave1 = sin(p.x * 14.0 + t);
    float wave2 = sin(14.0 * (p.x * sin(t * 0.5) + p.y * cos(t * 0.3)) + t);
    float wave3 = length(p) * 28.0 - t;

    float plasma = sin(wave1 + wave2 + sin(wave3));

    float intensity = (plasma + 1.0) * 0.5;
    intensity = smoothstep(0.15, 0.85, intensity);

    // Lava red palette
    vec3 darkRed   = vec3(0.03, 0.00, 0.00);
    vec3 crimson   = vec3(0.50, 0.05, 0.00);
    vec3 hotPink   = vec3(0.95, 0.25, 0.00);
    vec3 highlight = vec3(1.00, 0.70, 0.20);

    vec3 color1 = mix(darkRed, crimson,
        clamp(intensity * 2.0, 0.0, 1.0));

    vec3 color2 = mix(crimson, hotPink,
        clamp((intensity - 0.25) * 1.5, 0.0, 1.0));

    vec3 finalColor = mix(color1, color2,
        clamp(intensity * 1.2, 0.0, 1.0));

    finalColor = mix(finalColor, highlight,
        pow(intensity, 6.0) * 0.4);

    gl_FragColor = vec4(finalColor, 1.0);
}