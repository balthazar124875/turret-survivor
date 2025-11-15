extends Trap

@export var pull_speed: float
@export var pull_vfx: PackedScene

@export var pull_radius: float
@export var magnetic: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var vfx = pull_vfx.instantiate()
	vfx.global_position = global_position
	get_node("/root/EmilScene/ParticleNode").add_child(vfx)
	
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if (distance < pull_radius):
					var vector_dir = (global_position - enemy.global_position).normalized() * (distance - 25) 
					enemy.take_hit(base_damage, "Gravity Trap", damage_type)
					enemy.add_displacement(vector_dir, pull_speed)
					
	if(magnetic):
		var traps := get_tree().root.find_children("*", "Trap", true, false)
		for trap in traps:
			if trap == self || (global_position.distance_to(trap.global_position) > pull_radius):
				continue

			var tween = get_tree().create_tween()
			tween.tween_property(trap, "global_position", global_position, 0.2)
					
	queue_free()
