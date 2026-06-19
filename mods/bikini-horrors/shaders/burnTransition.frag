#pragma header

uniform float time; // Animate this over time
uniform float resolution; // Pixelation amount (e.g., 5.0)

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 fragCoord = uv * openfl_TextureSize;

    vec2 lowresxy = vec2(
        floor(fragCoord.x / resolution),
        floor(fragCoord.y / resolution)
    );

    if (sin(time) > rand(lowresxy)) {
        vec4 texColor = flixel_texture2D(bitmap, uv);
        gl_FragColor = texColor;
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); // Dissolve to black
    }
}
