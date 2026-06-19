#pragma header

uniform float strength;
uniform float time;
uniform float amplitude;
uniform float frequency;
uniform float speed;

uniform vec3 tintColor;
uniform float tintAmount;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    float wave = sin(uv.y * frequency + time * speed) * amplitude;
    uv.x += wave * strength;

    vec4 tex = flixel_texture2D(bitmap, uv);

    // grayscale
    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

    vec3 original = tex.rgb;
    vec3 tinted   = gray * tintColor;

    // blend original <-> tinted
    vec3 finalColor = mix(original, tinted, tintAmount);

    gl_FragColor = vec4(finalColor, tex.a);
}