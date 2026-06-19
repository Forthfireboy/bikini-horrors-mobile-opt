#pragma header
uniform float iNumber;
uniform bool iMirror;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 scaledUV = uv * iNumber;
    vec2 finalUV;

    if (iMirror) {
        finalUV.x = (mod(floor(scaledUV.x), 2.0) == 1.0) ? 1.0 - fract(scaledUV.x) : fract(scaledUV.x);
        finalUV.y = (mod(floor(scaledUV.y), 2.0) == 1.0) ? 1.0 - fract(scaledUV.y) : fract(scaledUV.y);
    } else {
        finalUV = fract(scaledUV);
    }

    gl_FragColor = flixel_texture2D(bitmap, finalUV);
}