#pragma header

uniform float strength; // 0.0 = normal, 1.0 = maximum pixelation

void main()
{
    vec2 uv = openfl_TextureCoordv;

    // Adjust these values to control the maximum block size
    float maxPixelSize = 64.0;

    // Interpolate from 1 pixel to maxPixelSize
    float pixelSize = mix(1.0, maxPixelSize, strength);

    vec2 resolution = openfl_TextureSize;

    vec2 pixelUV = floor(uv * resolution / pixelSize) * pixelSize / resolution;

    gl_FragColor = flixel_texture2D(bitmap, pixelUV);
}