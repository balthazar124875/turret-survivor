extends TextureRect

var t = 0
var active: bool = false
var m: ShaderMaterial

func _ready():
	if material and material is ShaderMaterial:
		material = material.duplicate()
		
func _process(delta):
	t += delta
	var shader_mat := material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("time", t)

func update(active:bool, color: Color = Color(1,1,1)):
	var shader_mat := material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("active", active)
		shader_mat.set_shader_parameter("outline_color", color)
	
