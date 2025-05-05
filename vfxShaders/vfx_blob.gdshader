shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

//Source: https://godotshaders.com/snippet/2d-noise/
vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

const vec3 COLOR_CYAN = vec3(0,216,255) / 255.0;
const vec3 COLOR_BLACK = vec3(0,0,0);
const vec3 COLOR_RED = vec3(1,0,0);
const vec3 COLOR_DARK_BLUE = vec3(0, 0.0, 1.0);
const vec3 COLOR_CYAN2 = vec3(0,191,255) / 255.0;

void fragment() {
	float speed = 2.0;
	vec2 scrollSpeed = TIME * vec2(0.5, 0.25) * speed;
	
	float uvScalingY = 3.0;
	float noise = noise(UV*uvScalingY+scrollSpeed);
	
	vec2 circleCentre = vec2(0.5, 0.5);
	float distToCentre = distance(circleCentre, UV);
	float color = smoothstep(0.5, 0.15, distToCentre);
	
	
	//float border = smoothstep(0.6, 0.4, distToCentre);
	//vec3 borderColor = COLOR_BLACK * border;  // red
	
	//color = color*0.7 * step(noise, color);
	color = mix(noise, 1.0, color*0.7) * color*1.4;
	
	vec3 blobColor = COLOR_CYAN * color;
	
	color = smoothstep(0.1, 0.5, color); //Gives a nice border
	vec3 borderColor = COLOR_DARK_BLUE*6.0;
	vec3 finalColor = mix(borderColor, blobColor, color*0.9);
	
	COLOR = vec4(finalColor,1.0 * color);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
