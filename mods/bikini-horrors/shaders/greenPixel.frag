#pragma header

uniform float strength;

// Game Boy palette
vec3 color0 = vec3(15.0/255.0, 56.0/255.0, 15.0/255.0);
vec3 color1 = vec3(48.0/255.0, 98.0/255.0, 48.0/255.0);
vec3 color2 = vec3(139.0/255.0, 172.0/255.0, 15.0/255.0);
vec3 color3 = vec3(155.0/255.0, 188.0/255.0, 15.0/255.0);

void main()
{
    vec4 texColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

    // grayscale brightness
    float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));

    vec3 gbColor;

    if (gray < 0.25)
        gbColor = color0;
    else if (gray < 0.5)
        gbColor = color1;
    else if (gray < 0.75)
        gbColor = color2;
    else
        gbColor = color3;

    // Blend original -> gameboy
    vec3 finalColor = mix(texColor.rgb, gbColor, strength);

    gl_FragColor = vec4(finalColor, texColor.a);
}
