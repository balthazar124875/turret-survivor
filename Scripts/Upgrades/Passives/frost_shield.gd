extends PassiveUpgrade

@export var procChance = 0.1 #10%
@export var duration = 1.0 #10%

@export var luckScaling = 0.05

var coc

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		var freeze = StatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN, duration, 1)
		enemy.apply_status_effect(freeze)

func apply_level_up():
	if(upgradeAmount == 10):
			coc = true
			return
	
	match upgradeAmount % 2:
		0:
			duration += 0.1
		1:
			procChance += 0.05

func get_description() -> String:
	var text = TooltipHelper.get_luck_scaling_format(procChance, luckScaling, player.luck) + " to freeze enemeis that hit the player for [color=yellow]" + str(duration) + "[/color] seconds"
	if(coc):
		text += "\nLvl [color=yellow]10[/color]: Launches a freezing gust in a cone when hit [color=red](Not implemented)"
	return text
