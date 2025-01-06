extends Node2D

@export var background_shaders: Array[ShaderMaterial] = []
@export var transition_shaders: Array[ShaderMaterial] = []

@export var time_between_transitions: int = 5
@export var linear_parameter_bound: float = 1
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

var sin_background_parameter_1: float
var sin_background_parameter_2: float

var transitioning: bool
var transition_layer: AnimatedSprite2D
var transition_progress: float
var transitioning_to_black: bool
var current_transition_index: int

func _ready() -> void:
	layer1_rect = $BgLayer1ColorRect
	layer2_rect = $BgLayer2ColorRect
	layer1_sprite = $BgLayer1ASprite
	layer2_sprite = $BgLayer2ASprite
	transition_layer = $TransitionASprite
	transitioning = false;
	transition_layer.visible = false;
	print("ready")
	pass

func handle_transition(delta: float) -> void:
	transition_layer.visible = true
	transition_layer.material.set_shader_parameter("progress", transition_progress)
	#print("transition progress: " + str(transition_progress))
	if(transitioning_to_black):
		transition_progress += delta
	else:
		transition_progress -= delta
	if(transition_progress >= 1.0):
		print("transition at full progress")
		transition_progress = 1.0
		current_shader = background_shaders[current_shader_index % background_shaders.size()]
		layer1_sprite.material = current_shader
		transitioning_to_black = false
	if(transition_progress < 0.0):
		print("transition fully transparent")
		transition_progress = 0.0
		transition_layer.visible = false
		transitioning = false
	
	pass

func _process(delta: float) -> void:
	# Advance graphical parameters. Framerate dependent?
	background_value_sine_1 += delta
	background_value_sine_2 += delta
	background_parameter_linear += delta
	background_value_sine_1 = fmod(background_value_sine_1, 1)
	background_value_sine_2 = fmod(background_value_sine_2, 1)
	sin_background_parameter_1 = sin(background_value_sine_1)
	sin_background_parameter_2 = sin(background_value_sine_2)
	background_parameter_linear = fmod(background_parameter_linear, linear_parameter_bound)
	
	timer += delta
	if(transitioning):
		handle_transition(delta)
	if (timer > time_between_transitions):
		timer = 0
		print("shader index: " + str(current_shader_index))
		print("transition index: " + str(current_transition_index))

		current_shader_index = current_shader_index + 1 % background_shaders.size()
		#next_shader_index = next_shader_index + 1 % background_shaders.size() - 1
		current_transition_index = current_transition_index + 1 % transition_shaders.size() 
		transitioning = true
		transitioning_to_black = true
		transition_progress = 0.0
		transition_layer.material = transition_shaders[current_transition_index % transition_shaders.size()]
		print("transitioning...")
	


	pass
