extends PassiveUpgrade

@export var heal_mult = 2	

func ApplyWhenIncomeTickEffect(player: Player) -> void:
	player.heal_damage(heal_mult * player.gold_income, "Income heal")
