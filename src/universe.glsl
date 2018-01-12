#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform float subsecond;

vec2 offset;
float x;
float y;
float d;
float rx;
float ry;
float randRes;

float rand(vec2 seed);

float hasStar() {
        if (randRes > 0.95) {
                float cx = rx * d;
                float cy = ry * d;

                float r = sqrt(pow(x - cx, 2.0) + pow(y - cy, 2.0));
                return 1.0 - ((r * 2.0) / d);
        }
        return 0.0;
}

vec4 starColor() {
        return vec4(
                abs(mod(y - x, 255.0)) / 255.0,
                abs(mod(x + y, 255.0)) / 255.0,
                abs(mod(x - y, 255.0)) / 255.0,
                1.0
        ) * 1.5;
}

float blink() {
        if (randRes > 0.98) {
                return sin(randRes/3.0+(offset.x+offset.y+gl_FragCoord.x)/d)/2.0 + 0.5;
        }
        return 1.0;
}

void main() {
          offset = vec2(time * 10.0 + sin(time * 8.0), time * 100.0);
        x = floor(offset.x + gl_FragCoord.x + 0.5);
        y = floor(offset.y + gl_FragCoord.y + 0.5);
        d = 16.0;
        rx = floor(x / d + 0.5);
        ry = floor(y / d + 0.5);
        randRes = rand(vec2(rx, ry));
        vec4 result = starColor() * hasStar() * blink();
        gl_FragColor = result;
}

float rand(vec2 seed) {
        return fract(sin(dot(seed.xy, vec2(12.9898, 78.233))) * 43758.5453);
}
