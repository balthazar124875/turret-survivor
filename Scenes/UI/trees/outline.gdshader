shader_type canvas_item;

uniform vec4 outline_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_thickness = 2.0;
uniform float outline_strength = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float alpha = tex_color.a;
    float is_outline = 0.0;

    if (alpha < 0.1) {
        for (float x = -outline_thickness; x <= outline_thickness; x++) {
            for (float y = -outline_thickness; y <= outline_thickness; y++) {
                vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
                vec4 sample = texture(TEXTURE, UV + offset);
                if (sample.a > 0.1) {
                    is_outline = 1.0;
                }
            }
        }
    }

    if (is_outline > 0.0) {
        COLOR = vec4(outline_color.rgb, outline_color.a * outline_strength);
    } else if (alpha > 0.1) {
        COLOR = tex_color;
    } else {
        discard;
    }
}
