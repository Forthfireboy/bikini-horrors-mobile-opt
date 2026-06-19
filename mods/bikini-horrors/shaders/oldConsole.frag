#pragma header

// https://www.shadertoy.com/view/MdfXDH

uniform bool NES;
uniform bool GAMEBOY;
uniform bool EGA;
#define BRIGHTNESS 1.0

vec3 find_closest (vec3 ref) {
	vec3 old = vec3 (100.0*255.0);
	#define TRY_COLOR(new) old = mix (new, old, step (length (old-ref), length (new-ref)));

	if (NES == true) {
		TRY_COLOR (vec3 (0.0, 88.0, 0.0));
		TRY_COLOR (vec3 (80.0, 48.0, 0.0));
		TRY_COLOR (vec3 (0.0, 104.0, 0.0));
		TRY_COLOR (vec3 (0.0, 64.0, 88.0));
		TRY_COLOR (vec3 (0.0, 120.0, 0.0));
		TRY_COLOR (vec3 (136.0, 20.0, 0.0));
		TRY_COLOR (vec3 (0.0, 168.0, 0.0));
		TRY_COLOR (vec3 (168.0, 16.0, 0.0));
		TRY_COLOR (vec3 (168.0, 0.0, 32.0));
		TRY_COLOR (vec3 (0.0, 168.0, 68.0));
		TRY_COLOR (vec3 (0.0, 184.0, 0.0));
		TRY_COLOR (vec3 (0.0, 0.0, 188.0));
		TRY_COLOR (vec3 (0.0, 136.0, 136.0));
		TRY_COLOR (vec3 (148.0, 0.0, 132.0));
		TRY_COLOR (vec3 (68.0, 40.0, 188.0));
		TRY_COLOR (vec3 (120.0, 120.0, 120.0));
		TRY_COLOR (vec3 (172.0, 124.0, 0.0));
		TRY_COLOR (vec3 (124.0, 124.0, 124.0));
		TRY_COLOR (vec3 (228.0, 0.0, 88.0));
		TRY_COLOR (vec3 (228.0, 92.0, 16.0));
		TRY_COLOR (vec3 (88.0, 216.0, 84.0));
		TRY_COLOR (vec3 (0.0, 0.0, 252.0));
		TRY_COLOR (vec3 (248.0, 56.0, 0.0));
		TRY_COLOR (vec3 (0.0, 88.0, 248.0));
		TRY_COLOR (vec3 (0.0, 120.0, 248.0));
		TRY_COLOR (vec3 (104.0, 68.0, 252.0));
		TRY_COLOR (vec3 (248.0, 120.0, 88.0));
		TRY_COLOR (vec3 (216.0, 0.0, 204.0));
		TRY_COLOR (vec3 (88.0, 248.0, 152.0));
		TRY_COLOR (vec3 (248.0, 88.0, 152.0));
		TRY_COLOR (vec3 (104.0, 136.0, 252.0));
		TRY_COLOR (vec3 (252.0, 160.0, 68.0));
		TRY_COLOR (vec3 (248.0, 184.0, 0.0));
		TRY_COLOR (vec3 (184.0, 248.0, 24.0));
		TRY_COLOR (vec3 (152.0, 120.0, 248.0));
		TRY_COLOR (vec3 (0.0, 232.0, 216.0));
		TRY_COLOR (vec3 (60.0, 188.0, 252.0));
		TRY_COLOR (vec3 (188.0, 188.0, 188.0));
		TRY_COLOR (vec3 (216.0, 248.0, 120.0));
		TRY_COLOR (vec3 (248.0, 216.0, 120.0));
		TRY_COLOR (vec3 (248.0, 164.0, 192.0));
		TRY_COLOR (vec3 (0.0, 252.0, 252.0));
		TRY_COLOR (vec3 (184.0, 184.0, 248.0));
		TRY_COLOR (vec3 (184.0, 248.0, 184.0));
		TRY_COLOR (vec3 (240.0, 208.0, 176.0));
		TRY_COLOR (vec3 (248.0, 120.0, 248.0));
		TRY_COLOR (vec3 (252.0, 224.0, 168.0));
		TRY_COLOR (vec3 (184.0, 248.0, 216.0));
		TRY_COLOR (vec3 (216.0, 184.0, 248.0));
		TRY_COLOR (vec3 (164.0, 228.0, 252.0));
		TRY_COLOR (vec3 (248.0, 184.0, 248.0));
		TRY_COLOR (vec3 (248.0, 216.0, 248.0));
		TRY_COLOR (vec3 (248.0, 248.0, 248.0));
		TRY_COLOR (vec3 (252.0, 252.0, 252.0));
	}

	if (GAMEBOY == true) {
		TRY_COLOR (vec3 (156.0, 189.0, 15.0));
		TRY_COLOR (vec3 (140.0, 173.0, 15.0));
		TRY_COLOR (vec3 (48.0, 98.0, 48.0));
		TRY_COLOR (vec3 (15.0, 56.0, 15.0));
	}

	if (EGA == true) {
		TRY_COLOR (vec3 (0.0, 0.0, 0.0));
		TRY_COLOR (vec3 (255.0, 255.0, 255.0));
		TRY_COLOR (vec3 (255.0,  0.0,  0.0));
		TRY_COLOR (vec3 (  0.0,255.0,  0.0));
		TRY_COLOR (vec3 (  0.0,  0.0,255.0));
		TRY_COLOR (vec3 (255.0,255.0,  0.0));
		TRY_COLOR (vec3 (  0.0,255.0,255.0));
		TRY_COLOR (vec3 (255.0,  0.0,255.0));
		TRY_COLOR (vec3 (128.0,  0.0,  0.0));
		TRY_COLOR (vec3 (  0.0,128.0,  0.0));
		TRY_COLOR (vec3 (  0.0,  0.0,128.0));
		TRY_COLOR (vec3 (128.0,128.0,  0.0));
		TRY_COLOR (vec3 (  0.0,128.0,128.0));
		TRY_COLOR (vec3 (128.0,  0.0,128.0));
		TRY_COLOR (vec3 (128.0, 128.0, 128.0));
		TRY_COLOR (vec3 (255.0, 128.0, 128.0));
	}

	return old ;
}

float dither_matrix (float x, float y) {
	return mix(mix(mix(mix(mix(mix(0.0,32.0,step(1.0,y)),mix(8.0,40.0,step(3.0,y)),step(2.0,y)),mix(mix(2.0,34.0,step(5.0,y)),mix(10.0,42.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(48.0,16.0,step(1.0,y)),mix(56.0,24.0,step(3.0,y)),step(2.0,y)),mix(mix(50.0,18.0,step(5.0,y)),mix(58.0,26.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(1.0,x)),mix(mix(mix(mix(12.0,44.0,step(1.0,y)),mix(4.0,36.0,step(3.0,y)),step(2.0,y)),mix(mix(14.0,46.0,step(5.0,y)),mix(6.0,38.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(60.0,28.0,step(1.0,y)),mix(52.0,20.0,step(3.0,y)),step(2.0,y)),mix(mix(62.0,30.0,step(5.0,y)),mix(54.0,22.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(3.0,x)),step(2.0,x)),mix(mix(mix(mix(mix(3.0,35.0,step(1.0,y)),mix(11.0,43.0,step(3.0,y)),step(2.0,y)),mix(mix(1.0,33.0,step(5.0,y)),mix(9.0,41.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(51.0,19.0,step(1.0,y)),mix(59.0,27.0,step(3.0,y)),step(2.0,y)),mix(mix(49.0,17.0,step(5.0,y)),mix(57.0,25.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(5.0,x)),mix(mix(mix(mix(15.0,47.0,step(1.0,y)),mix(7.0,39.0,step(3.0,y)),step(2.0,y)),mix(mix(13.0,45.0,step(5.0,y)),mix(5.0,37.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(63.0,31.0,step(1.0,y)),mix(55.0,23.0,step(3.0,y)),step(2.0,y)),mix(mix(61.0,29.0,step(5.0,y)),mix(53.0,21.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(7.0,x)),step(6.0,x)),step(4.0,x));
}

vec3 dither (vec3 color, vec2 uv) {
	color *= 255.0 * BRIGHTNESS;
	color += dither_matrix (mod (uv.x, 8.0), mod (uv.y, 8.0));
	color = find_closest (clamp (color, 0.0, 255.0));
	return color / 255.0;
}

void main()
{
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
	gl_FragColor = vec4 (dither (flixel_texture2D(bitmap, openfl_TextureCoordv).xyz, fragCoord.xy),1.0);
}