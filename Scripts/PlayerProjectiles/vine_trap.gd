extends Trap

@export var vine: PackedScene
var vine_amount = 3
var root_duration = 1
var poison = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var random_offset = randf_range(0, 2 * PI)
	for i in vine_amount:
		var vine = vine.instantiate()
		get_parent().add_child(vine)
		vine.global_position = global_position
		vine.rotation = Vector2(1, 0).rotated(deg_to_rad(randf_range(0, 360))).angle()
		vine.damage = base_damage
		vine.root_duration = root_duration
		vine.poison = poison
	
	queue_free()
