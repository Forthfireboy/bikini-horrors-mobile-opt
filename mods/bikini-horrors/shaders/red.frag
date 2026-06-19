#pragma header

// Convert RGB -> HSV
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0*d + e)), d / (q.x + e), q.x);
}

// Convert HSV -> RGB
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void main() {
    vec4 texColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

    // Convert current color to HSV
    vec3 hsv = rgb2hsv(texColor.rgb);

    // Force hue to magenta (~0.01)
    hsv.x = 0.01;

    // Rebuild RGB with new hue, keep original saturation & value
    vec3 newColor = hsv2rgb(hsv);

    gl_FragColor = vec4(newColor, texColor.a);
}
