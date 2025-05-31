extends Trap

@export var eruption_radius: float

@export var eruption_vfx: PackedScene

var ignites: bool
var ignite_duration: float
var ignite_damage: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func trigger_trap():
	var vfx = eruption_vfx.instantiate()
	vfx.global_position = global_position
	get_node("/root/EmilScene/ParticleNode").add_child(vfx)
	
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if (distance < eruption_radius):
					if(ignites):
						var burnEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING, ignite_duration, ignite_damage)
						var effects: Array[EnemyStatusEffect] = [burnEffect]
						enemy.take_hit(base_damage, "Eruption Trap", GlobalEnums.DAMAGE_TYPES.FIRE, effects)
					else:
						enemy.take_hit(base_damage, "Eruption Trap", GlobalEnums.DAMAGE_TYPES.FIRE)
					
	queue_free()
