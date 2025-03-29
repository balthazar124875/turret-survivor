extends Trap

@export var vine: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

func trigger_trap():
	var random_offset = randf_range(0, 2 * PI) 
	for i in 3:
		var vine = vine.instantiate()
		get_parent().add_child(vine)
		vine.global_position = global_position
		var offset = Vector2(cos(random_offset + i * (2 * PI / 3)), sin(random_offset + i * (2 * PI / 3)))
		vine.rotation =  offset.angle()
	
	queue_free()
