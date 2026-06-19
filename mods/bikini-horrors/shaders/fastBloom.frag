#pragma header

// https://www.shadertoy.com/view/MdSyWh
// Ported by Nex_isDumb

// curve matched using turingbot
vec3 srgbToLinear(const vec3 x) {
    return 0.315206 * x * ((2.10545 + x) * (0.0231872 + x));
}
// curve matched using turingbot
vec3 linearToSrgb(const vec3 x) {
    return 1.14374 * (-0.126893 * x + sqrt(x));
}

vec3 t(vec2 p,float m) {
    return srgbToLinear(flixel_texture2D(bitmap, p, m).rgb);
}

vec3 fastBloom (vec2 p,vec2 r) {
    float mip = 2.;
    float scale = exp2(mip);
    vec3 c =
        t((p + vec2(-1.5, -0.5) * scale) / r, mip)* .1 +
        t((p + vec2( 0.5, -1.5) * scale) / r, mip)* .1 +
        t((p + vec2( 1.5, 0.5) * scale) / r, mip)* .1 +
        t((p + vec2(-0.5, 1.5) * scale) / r, mip)* .1 +
        t((p) / r, mip) * .7 +
        t(p / r, 0.) * .7;
    return c;
}

vec3 jodieRobo2(const vec3 d) {
    float c = dot(d, vec3(.2126, .7152, .0722));
    vec4 e = vec4(d, c)*inversesqrt(c * c + 1.);
    vec3 a = e.rgb;
    float b = e.a;
    float f = max(max(max(e.r, e.g), e.b), 1.);
    return (b * a - a - (f * b - b)) / (b - f);
}

void main()
{
    vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize.xy;
    fragCoord.y = 1. - fragCoord.y;
    vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
    vec3 color = fastBloom(fragCoord.xy, openfl_TextureSize.xy);

    color = jodieRobo2(color);

    gl_FragColor = linearToSrgb(color);
}