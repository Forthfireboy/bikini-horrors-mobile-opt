//Aika was here

#pragma header

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 base = flixel_texture2D(bitmap, uv); 
    
    //JODER HAXE NO ME LO PONGAS TRANSPARENTE
    if (base.a <= 0.0) base.a = 1.0;

    float angle = 0.1; 
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    
    vec2 rotatedUV = (rot * (uv - 0.5)) + 0.5;
    
    // Mossaic
    float x = mod(rotatedUV.x * 150.0, 1.0);
    float y = mod(rotatedUV.y * 150.0, 1.0);
    
    float pattern = pow(abs(0.5 - x) + abs(0.5 - y), 2); 
    
    pattern = 1.0 - pattern;
    pattern = max(pattern, 0.8); 

    gl_FragColor = vec4(base.rgb * pattern, base.a);
}
