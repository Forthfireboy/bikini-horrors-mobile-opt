#pragma header
uniform float progress;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(46.9898,94.233))) * 43758.5453);
}

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    float noise = rand(openfl_TextureCoordv * 100.0); 
    float threshold = (openfl_TextureCoordv.x * 0.9) + (noise * 0.1);

    if (threshold > progress) {
        gl_FragColor = vec4(0.0);
    } else {
        gl_FragColor = color;
    }
}