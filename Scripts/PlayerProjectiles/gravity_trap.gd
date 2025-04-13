extends Trap

@export var pull_speed: float
@export var pull_vfx: PackedScene

@export var radius: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if (distance < radius):
					var vector_dir = (enemy.global_position - global_position).normalized() * 25
					enemy.addDisplacement(global_position + vector_dir, pull_speed)
					enemy.take_damage(base_damage, "Gravity Trap", GlobalEnums.DAMAGE_TYPES.MAGIC)
	queue_free()
