extends AugmentUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var knockback_distance = 150
@export var knockback_speed = 400

@export var procChance = 0.2
@export var luckScaling = 0.02

func _ready() -> void:
	SignalBus.damage_done.connect(knockback)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func knockback(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	var vector_dir = (enemy.global_position - player.global_position).normalized() * knockback_distance
	if(direct && damageType == GlobalEnums.DAMAGE_TYPES.LIGHTNING):
		var rndNumber = randf_range(0.0, 1.0);
		if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
			enemy.add_displacement(vector_dir, knockback_speed)
