extends Control

var damage_numbers_scene = preload("res://Scenes/UI/damage_numbers.tscn")
@onready var particle_node = get_node("/root/EmilScene/ParticleNode")

@export var damage_number_active: bool = true

func _ready() -> void:
	SignalBus.damage_done.connect(_spawn_numbers)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_numbers(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(damage_number_active):
		
		var number_exist = particle_node.get_node_or_null(str(enemy.get_instance_id()) + source)
		if number_exist && number_exist.time_since_change < 0.1:
			number_exist.global_position = enemy.global_position
			number_exist.update_number(number_exist.number + amount)
			var percentage = (number_exist.number + amount)/ enemy.max_health
			var strength = max(min(percentage * 20, 1), 0.25)
			number_exist.modulate = Color(1, 1, 1, strength)
			
			
		else:
			var new_damage_numbers = damage_numbers_scene.instantiate()
			new_damage_numbers.name = str(enemy.get_instance_id()) + source
			new_damage_numbers.global_position = enemy.position
			new_damage_numbers.number = amount
			new_damage_numbers.damage_type = damageType
			particle_node.add_child(new_damage_numbers)
			var percentage = amount / enemy.max_health
			var strength = max(min(percentage * 20, 1), 0.25)
			new_damage_numbers.modulate = Color(1, 1, 1, strength)
		
