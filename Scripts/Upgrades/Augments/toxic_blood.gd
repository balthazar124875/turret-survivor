extends AugmentUpgrade

@export var duration = 5

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	if(player.healthRegeneration > 0):
		var poisonEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED, duration, player.healthRegeneration / duration)
		enemy.apply_status_effect(poisonEffect)

func get_description() -> String:
	return "Taking damage poisons enemy dealing [color=green]" + str(player.healthRegeneration * duration / 2) + "[/color] over [color=yellow]" + str(duration) + "[/color] seconds"
