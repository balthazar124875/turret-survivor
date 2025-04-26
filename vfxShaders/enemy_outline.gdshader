shader_type canvas_item;

uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0); // Black by default
uniform vec4 inner_color = vec4(1, 1, 1, 1.0); // Black by default
uniform float outline_size = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
	
	
	
    if (tex.a < 0.1) {
        //Sample surrounding pixels to create an outline
        float alpha = 0.0;
        for (float x = -outline_size; x <= outline_size; x++) {
            for (float y = -outline_size; y <= outline_size; y++) {
                vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
				
                alpha = max(alpha, texture(TEXTURE, UV + offset).a);
            }
        }
		
        if (alpha > 0.1) {
            COLOR = outline_color;
        } else {
            discard;
        }
    } else {
		COLOR *= inner_color;
    }
}