#pragma header

// https://www.shadertoy.com/view/tllSz2
// Ported by Nex_isDumb

void main()
{
    vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = vec4(vec3(dot(tex.rgb, vec3(.5, .5, .5))), tex.a);
}