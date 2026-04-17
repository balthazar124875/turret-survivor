extends AugmentUpgrade

@export var dust_amount = 5

@export var procChance = 0.2
@export var luckScaling = 0.05

var total_gained = 0

func _ready() -> void:
	SignalBus.enemy_killed.connect(on_enemy_killed)
	pass # Replace with function body.

func on_enemy_killed(enemy: Enemy):
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		player.modify_dust(dust_amount)
		total_gained += dust_amount

func get_description() -> String:
	var text = "Has a " + TooltipHelper.get_luck_scaling_format(procChance, luckScaling, player.luck) + " chance to gain [color=cyan]" + String.num(dust_amount, 0) + "[/color]" + IconHandler.get_icon_path("dust") + " when an enemy is killed"

	text += "\n[b]Dust gained: [/b][color=cyan]" + str(total_gained) + "[/color]" + IconHandler.get_icon_path("dust")
	return text 
