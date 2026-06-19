#pragma header

void main() {
    vec4 texColor = textureCam(bitmap, openfl_TextureCoordv);
    gl_FragColor = vec4(0.0, 0.0, 0.0, texColor.a);
}
