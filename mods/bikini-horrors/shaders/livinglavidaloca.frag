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

    vec3 darkPurple = vec3(0.20, 0.12, 0.30);
    vec3 neonPurple = vec3(0.55, 0.35, 0.75);
    vec3 white = vec3(0.80, 0.74, 0.90);

    vec3 color1 = mix(darkPurple, neonPurple, clamp(intensity * 2.0, 0.0, 1.0));
    vec3 color2 = mix(neonPurple, white, clamp((intensity - 0.5) * 2.0, 0.0, 1.0));

    vec3 finalColor = mix(color1, color2, step(0.5, intensity));

    gl_FragColor = vec4(finalColor, 1.0);
}