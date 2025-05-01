extends Control

var damage_numbers_scene = preload("res://Scenes/UI/damage_numbers.tscn")

@export var damage_number_active: bool = true

func _ready() -> void:
	SignalBus.damage_done.connect(_spawn_numbers)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_numbers(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(damage_number_active):
		var new_damage_numbers = damage_numbers_scene.instantiate()
		new_damage_numbers.global_position = enemy.position
		new_damage_numbers.number = amount
		new_damage_numbers.damage_type = damageType
		get_node("/root/EmilScene/ParticleNode").add_child(new_damage_numbers)
