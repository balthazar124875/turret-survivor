extends PassiveUpgrade

@export var heal_amount: float = 3;

var extra_effect = false

func _ready() -> void:
	SignalBus.enemy_killed.connect(on_enemy_killed)
	pass # Replace with function body.

func on_enemy_killed(enemy: Enemy):
	if enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED) or enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING):	
		player.heal_damage(heal_amount, "Suffering")

func apply_level_up():
	if(upgradeAmount == 10):
		extra_effect = true
		return
	
	heal_amount += 3

func get_description() -> String:
	var text = "Killing a poisoned or burning enemy restores [color=red]" + String.num(heal_amount, 0) + "[/color]" + IconHandler.get_icon_path("health")
	if(extra_effect):
		text += "\nLvl [color=yellow]10[/color]: [color=red](Not implemented)"
	return text
