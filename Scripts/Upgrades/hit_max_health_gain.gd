extends PassiveUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var heal = false

@export var max_health_gain = 1	
@export var procChance = 0.2
@export var luckScaling = 0.04

func ApplyWhenHitEffect(player: Player, enemy : Enemy) -> void:
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		player.modify_max_health(max_health_gain)
		if(heal):
			player.heal_damage(max_health_gain * 2, "Strong Heart")

func apply_level_up():
	if(upgradeAmount == 10):
		heal = true
		return
	
	match upgradeAmount % 2:
		1:
			procChance += 0.1
		2:
			max_health_gain += 1
