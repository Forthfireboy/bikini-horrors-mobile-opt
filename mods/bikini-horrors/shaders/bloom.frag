#pragma header
 
uniform float brightness;
uniform float directions;
uniform int quality;
uniform float size;
 
#define PI 3.141592653589793
#define TWO_PI 6.283185307179586
 
void main(void) {
vec2 uv = openfl_TextureCoordv.xy;
vec4 color = textureCam(bitmap, uv);
vec4 bloom = color;
 
if (brightness == 1.0 && size == 0.0) {
gl_FragColor = color;
return;
}
 
float maxApply = 0.0;

float dir = min(directions, 8.0);
for (float d = 0.0; d < TWO_PI; d += TWO_PI / dir) {
float q = min(float(quality), 16.0);
for (float i = 1.0 / q; i <= 1.0; i += 1.0 / q) {
float x_movement = (sin(d) * size * i) / openfl_TextureSize.y;
float y_movement = (cos(d) * size * i) / openfl_TextureSize.x;
bloom += textureCam(bitmap, uv + vec2(x_movement, y_movement));
bloom *= mix(1.0, 1.0 - (i / q), step(0.0, x_movement) + step(0.0, y_movement));
maxApply += 1.0;
}
}
 
float brightnessFactor = 1.0 - (1.0 / maxApply);
bloom /= maxApply;
 
float brightnessApply = brightness;
if (brightness < 1.5)
brightnessApply = mix(1.5, 0.0, abs(1.0-((brightness-1.0)*2.0)));
 
gl_FragColor = color + ((bloom * brightnessFactor) * brightnessApply);
}
 
