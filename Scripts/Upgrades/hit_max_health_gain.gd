extends PassiveUpgrade

@export var max_health_gain = 1	

func ApplyWhenHitEffect(player: Player, enemy : Enemy) -> void:
	player.modify_max_health(max_health_gain)
