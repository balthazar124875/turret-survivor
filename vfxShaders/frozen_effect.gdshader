shader_type canvas_item;

uniform sampler2D normal_map;
uniform sampler2D diffuseTex;
uniform float uv_scale = 0.11;
uniform float uv_offset = 0.0;
uniform float colorIntensity = 1.0;
uniform float refraction_strength : hint_range(0.0, 1.0) = 0.03;
uniform bool use_screen_texture = true;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    // Sample normal from normal map
    vec3 normal = texture(normal_map, UV * uv_scale + uv_offset).rgb * 2.0 - 1.0;
    
    // Convert normal map from [0,1] to [-1,1] range
    vec2 offset = (normal.xy) * refraction_strength;


	
	//vec2 screen_res = 1.0 / SCREEN_PIXEL_SIZE;
	//vec2 pixel_pos = SCREEN_UV * screen_res;
	//vec2 virtual_res = vec2(1000, 1000);
	//pixel_pos = pixel_pos / virtual_res;

    // Get distorted screen UV
    vec2 refract_uv = SCREEN_UV + offset;

    // Sample screen color using distorted UVs
    vec4 screen_color = texture(SCREEN_TEXTURE, refract_uv);

    // You can blend with a frost tint if desired
    vec3 ice_tint = vec3(0.6, 0.8, 1.0);
	float fresnel = length(normal);
	float blend = clamp(colorIntensity*fresnel, 0, 1);
	blend = smoothstep(0.4, 1.0, blend);
    screen_color.rgb = mix(screen_color.rgb, ice_tint, blend);
	
    COLOR = vec4(screen_color.rgb, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
