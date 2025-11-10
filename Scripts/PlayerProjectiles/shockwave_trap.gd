extends Trap

@export var knockback_radius: float
@export var knockback_distance: float
@export var delayed_detonation: bool = false
@export var knockback_speed: float = false

@export var shockwave_vfx: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var vfx = shockwave_vfx.instantiate()
	vfx.global_position = global_position
	get_node("/root/EmilScene/ParticleNode").add_child(vfx)
	
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if (distance < knockback_radius):
					var vector_dir = (enemy.global_position - global_position).normalized() * knockback_distance
					
					enemy.take_hit(base_damage, "ShockWave Trap", damage_type)
					
					enemy.add_displacement(vector_dir, knockback_speed)
						
						
	if(delayed_detonation):
		await get_tree().create_timer(1).timeout
		trigger_trap()
	queue_free()
