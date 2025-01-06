extends AnimatedSprite2D

@export var shaders: Array[ShaderMaterial] = []
@export var time_between_transitions: int
@export var linear_parameter_bound: float = 1
#@export var sinusoidal_parameter_bound: float = 1
var background_value_sine_1: float = 0
var background_value_sine_2: float = 0.5
var background_parameter_linear: float = 0
var layer1_rect: ColorRect
var layer2_rect: ColorRect
var layer1_sprite: AnimatedSprite2D
var layer2_sprite: AnimatedSprite2D
var timer: float = 0
var current_shader_index: int = 0
var current_shader: ShaderMaterial
var next_shader_index: int = 1
var next_shader: ShaderMaterial
var sin_background_parameter_1 : float
var sin_background_parameter_2 : float

func _ready() -> void:
	layer1_rect = $BgLayer1ColorRect
	layer2_rect = $BgLayer2ColorRect
	layer1_sprite = $BgLayer1ASprite
	layer2_sprite = $BgLayer2ASprite
	pass

# Saw is not automatic
func _process(delta: float) -> void:
	# Advance graphical parameters. Make framerate dependent?
	background_value_sine_1 += delta
	background_value_sine_2 += delta
	background_parameter_linear += delta
	background_value_sine_1 = fmod(background_value_sine_1, 1)
	background_value_sine_2 = fmod(background_value_sine_2, 1)
	sin_background_parameter_1 = sin(background_value_sine_1)
	sin_background_parameter_2 = sin(background_value_sine_2)
	background_parameter_linear = fmod(background_parameter_linear, linear_parameter_bound)
	
	timer += delta
	if (timer > time_between_transitions):
		timer = 0
		current_shader_index = current_shader_index + 1 % shaders.size()
		next_shader_index = next_shader_index + 1 % shaders.size()
		
		# Apply transition shader here...
		# 1. Make transition shader visible
		# 2. Let it run its course
		# 3. Make the 
		# 1. Make layer for next_shader visible
		# 2. Apply transition shader. How the fuck do I do this without multiple shaders????
		# 3. Make layer for current_shader invisible
	


	pass
