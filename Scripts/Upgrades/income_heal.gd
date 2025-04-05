extends PassiveUpgrade

@export var heal_mult = 0.5	

func ApplyWhenIncomeTickEffect(player: Player) -> void:
	player.heal_damage(heal_mult * player.gold_income, "Income heal")

func apply_level_up():
	if(upgradeAmount == 10):
		#heal = true
		return
	
	heal_mult += 0.25
