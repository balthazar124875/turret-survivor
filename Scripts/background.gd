extends Sprite2D

var progress : float = 0.0
var active : bool = false
var z_later : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if material and material is ShaderMaterial:
		material = material.duplicate()
	

func start_disolve(z_now: int, z_later: int):
	active = true
	progress = 0
	z_index = z_now
	self.z_later = z_later
	
	var x = randf_range(0, 1)
	var y = randf_range(0, 1)
	material.set_shader_parameter("start", Vector2(x, y))

func reset():
	z_index = 0
	progress = 0
	material.set_shader_parameter("progress", progress)
	
	var r = randf_range(0.5, 1)
	var g = randf_range(0.5, 1)
	var b = randf_range(0.5, 1)
	self_modulate = Color(r, g, b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(active):
		progress += delta
		material.set_shader_parameter("progress", progress)
		if(progress >= 1):
			active = false
			z_index = z_later
