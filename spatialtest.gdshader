// Adapted from https://www.shadertoy.com/view/XsG3Dc

shader_type spatial;

uniform vec4 alb_wood : source_color = vec4(.564, .356, .192, 1.);
uniform vec4 alb_gap : source_color = vec4(.353, .176, .07, 1.);
uniform float plank_length = 6.0;
uniform float scale = 10.;

float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

vec4 composit(in vec4 top, in vec4 bottom) {
    return vec4(mix(top.xyz, bottom.xyz, 1.0-top.a), 1.0);
}

void fragment() {
    vec2 uv = UV * scale;
    float plank = floor(uv.x); // unique per plank
    float start = 15. * rand(vec2(plank));
    float item = floor(uv.y / plank_length + start);
    
    float darkness = mix(1.0, 0.5+rand(vec2(plank, item)), 0.2);
    
    float plankGapY = step(0.0, fract(uv.x)) * (1.0 - step(0.02, fract(uv.x)));
    float plankGapX = step(0.0, fract(uv.y / plank_length + start)) * (1.0 - step(0.02 / plank_length, fract(uv.y / plank_length + start)));
   
    // final images
    vec4 gap = vec4(alb_gap.r, alb_gap.g, alb_gap.b, max(plankGapY, plankGapX));
    vec4 wood = vec4(alb_wood.rgb * darkness, 1.0);
    
    ALBEDO = composit(gap, wood).rgb;
}