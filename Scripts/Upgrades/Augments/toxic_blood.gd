extends AugmentUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var duration = 5

func ApplyWhenHitEffect(player: Player, enemy : Enemy) -> void:
	if(player.healthRegeneration > 0):
		var poisonEffect = EnemyStatusEffect.new()
		poisonEffect.type = GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
		poisonEffect.duration = duration
		poisonEffect.magnitude = player.healthRegeneration / duration
		enemy.apply_status_effect(poisonEffect)
