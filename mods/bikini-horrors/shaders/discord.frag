#pragma header

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 color = flixel_texture2D(bitmap, uv);
    float dist = distance(uv, vec2(0.5, 0.5));
    float mask = smoothstep(0.5, 0.35, dist);
    
    gl_FragColor = color * mask;
}