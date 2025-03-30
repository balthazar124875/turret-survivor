extends Trap

@export var vine: PackedScene
var vine_amount = 3
var root_duration = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var random_offset = randf_range(0, 2 * PI)
	for i in vine_amount:
		var vine = vine.instantiate()
		get_parent().add_child(vine)
		vine.global_position = global_position
		var offset = Vector2(cos(random_offset + i * (2 * PI / vine_amount)), sin(random_offset + i * (2 * PI / vine_amount)))
		vine.rotation =  offset.angle()
		vine.damage = base_damage
		vine.root_duration = root_duration
	
	queue_free()
