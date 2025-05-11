shader_type canvas_item;

uniform float time : hint_range(0, 100);
uniform float wave_width = 0.3; // Width of the wave transition
uniform float speed = 1.0;      // Speed of the rotation
uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0); // Black by default
uniform int wave_count = 6; // Number of repeating waves
uniform bool active = false; // Number of repeating waves

uniform float sharpness = 1.0; // Higher = thinner white band

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

	if(!active){
		COLOR = outline_color * tex_color;
	} else {
	    if (tex_color.a < 0.1) {
	        discard;
	    }

	    vec2 center_uv = UV - vec2(0.5);
	    float dist = length(center_uv); // Distance from center
	    float angle = atan(center_uv.y, center_uv.x);
	    angle = mod(angle + 6.2831, 6.2831); // Normalize to [0, 2PI]

	    // Multiply angle by number of waves to repeat them
	    float wave = sin(angle * float(wave_count) - time * speed);
		wave = abs(wave); // Make all waves positive
		float blend = pow(1.0 - wave, sharpness);

	    vec3 final_color = mix(outline_color.rgb, vec3(1), blend);
	    COLOR = vec4(final_color, tex_color.a);
	}

}