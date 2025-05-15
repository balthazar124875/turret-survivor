extends AugmentUpgrade

@export var duration = 5

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	if(player.healthRegeneration > 0):
		var poisonEffect = EnemyStatusEffect.new()
		poisonEffect.type = GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
		poisonEffect.duration = duration
		poisonEffect.magnitude = player.healthRegeneration / duration
		enemy.apply_status_effect(poisonEffect)

func get_description() -> String:
	return "Taking damage poisons enemy dealing [color=green]" + str(player.healthRegeneration * duration / 2) + "[/color] over [color=yellow]" + str(duration) + "[/color] seconds"
