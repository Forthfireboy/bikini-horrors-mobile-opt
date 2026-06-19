precision mediump float;

uniform sampler2D uSampler0;
uniform vec2 uResolution;
uniform float uTime;
uniform vec4 uMouse;

#define DOTSIZE 1.48
#define MIN_S 4.0
#define MAX_S 4.0
#define SPEED 0.0

#define SST 0.888
#define SSQ 0.288

vec4 rgb2cmyki(in vec3 c) {
    float k = max(max(c.r, c.g), c.b);
    return min(vec4(c.rgb / k, k), 1.0);
}

vec3 cmyki2rgb(in vec4 c) {
    return c.rgb * c.a;
}

vec2 px2uv(in vec2 px) {
    return px / uResolution;
}

vec2 grid(in vec2 px, float S) {
    return px - mod(px,S);
}

vec4 ss(in vec4 v) {
    return smoothstep(SST-SSQ, SST+SSQ, v);
}

mat2 rotm(in float r) {
    float cr = cos(r);
    float sr = sin(r);
    return mat2(cr,-sr,sr,cr);
}

vec4 halftoneSample(in vec2 fc, in mat2 m, float S) {
    vec2 smp = (grid(m*fc, S) + 0.5*S) * m;
    float s = min(length(fc-smp) / (DOTSIZE*0.5*S), 1.0);
    vec3 texc = texture2D(uSampler0, px2uv(smp + 0.5*uResolution)).rgb;
    texc = pow(texc, vec3(2.2));
    vec4 c = rgb2cmyki(texc);
    return c + s;
}

vec4 halftone(in vec2 fragCoord) {
    float R = SPEED*0.333*uTime;
    float S = MIN_S + (MAX_S-MIN_S) * (0.5 - 0.5*cos(SPEED*uTime));
    
    if (uMouse.z > 0.5) {
        S = MIN_S + (MAX_S-MIN_S) * 2.0*abs(uMouse.x-0.5*uResolution.x) / uResolution.x;
        R = radians(180.0 * (uMouse.y-0.5*uResolution.y) / uResolution.y);
    }
    
    vec2 fc = fragCoord - 0.5*uResolution;
    
    mat2 mc = rotm(R + radians(15.0));
    mat2 mm = rotm(R + radians(75.0));
    mat2 my = rotm(R);
    mat2 mk = rotm(R + radians(45.0));
    
    vec4 c = vec4(
        halftoneSample(fc, mc, S).r,
        halftoneSample(fc, mm, S).g,
        halftoneSample(fc, my, S).b,
        halftoneSample(fc, mk, S).a
    );
    
    vec3 rgb = cmyki2rgb(ss(c));
    rgb = pow(rgb, vec3(1.0/2.2));
    return vec4(rgb, 1.0);
}

// Sobel filter
mat3 sx = mat3(1.,2.,1., 0.,0.,0., -1.,-2.,-1.);
mat3 sy = mat3(1.,0.,-1., 2.,0.,-2., 1.,0.,-1.);

float luminance(vec3 color) {
    return 0.25*color.r + 0.5*color.g + 0.25*color.b;
}

vec3 sobel(in vec2 uv) {
    mat3 Y;
    for(int i=-1;i<=1;i++){
        for(int j=-1;j<=1;j++){
            vec2 pos = uv + vec2(float(i)/uResolution.x, float(j)/uResolution.y);
            vec3 c = texture2D(uSampler0,pos).rgb;
            Y[i+1][j+1] = luminance(c);
        }
    }
    float gx = dot(sx[0], Y[0]) + dot(sx[1], Y[1]) + dot(sx[2], Y[2]);
    float gy = dot(sy[0], Y[0]) + dot(sy[1], Y[1]) + dot(sy[2], Y[2]);
    return vec3(sqrt(gx*gx + gy*gy));
}

void main(void) {
    vec2 uv = gl_FragCoord.xy;
    vec4 fillColor = texture2D(uSampler0, uv/uResolution);
    vec4 htColor = halftone(uv);
    vec3 edge = sobel(uv/uResolution);
    
    vec3 final = (htColor.xyz + fillColor.xyz)/2.0 - edge;
    gl_FragColor = vec4(final, 1.0);
}
