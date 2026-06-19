#pragma header

void main() {
    vec4 texColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = vec4(0.0, texColor.g, 0.0, texColor.a);
}
