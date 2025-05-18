shader_type canvas_item;

uniform vec2 start = vec2(1, 1);
uniform vec4 margin_color = vec4(1, 1, 1, 1);
uniform vec4 modulate_color = vec4(1, 1, 1, 1);

uniform float progress = 0.0f;
uniform float margin = 0.0f;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float dist = abs(start.x-UV.x) + abs(start.y - UV.y);

	if(dist > progress * 2.0){
		if(progress == 0.0 || (dist - margin > progress * 2.0)){
		    //COLOR = COLOR;
		} else {
			COLOR = margin_color;
		}

	} else {
		discard;
	}
}
