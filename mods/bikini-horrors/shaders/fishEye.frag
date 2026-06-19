#pragma header

uniform float intensity; // Try 0.3
uniform float zoom;      // Try 1.0 to 1.5

void main() {
    vec2 uv = openfl_TextureCoordv;
    
    // 1. Center coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // 2. Aspect Ratio Correction
    float aspect = openfl_TextureSize.x / openfl_TextureSize.y;
    p.x *= aspect;
    
    // 3. The "Lens" Math
    float r = length(p);
    // This formula creates the barrel distortion
    // Higher intensity = more curve. 
    float projection = (1.0 - intensity * r * r);
    
    // 4. Apply distortion and zoom
    // Dividing by projection creates the 'warp'
    p *= projection * zoom;
    
    // 5. Restore Aspect and Move back to [0, 1]
    p.x /= aspect;
    vec2 distortedUV = (p + 1.0) / 2.0;

    // 6. Output
    if (distortedUV.x < 0.0 || distortedUV.x > 1.0 || distortedUV.y < 0.0 || distortedUV.y > 1.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black borders
    } else {
        gl_FragColor = flixel_texture2D(bitmap, distortedUV);
    }
}