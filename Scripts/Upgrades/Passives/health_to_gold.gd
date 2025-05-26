extends PassiveUpgrade

@export var max_health_removed: float = 500
@export var income_gold_gain: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func offerHealth() -> void:
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME, income_gold_gain)
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_MAX_HEALTH, -500)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_level_up():
	weight *= 2
	offerHealth()

func get_description() -> String:
	var text = "Sacrificed [color=red]" + str(max_health_removed * upgradeAmount) + "[/color] maximum health for [color=yellow]" + str(upgradeAmount * income_gold_gain) + "[/color] bonus income"
	text += "\n[b][color=red]CURSED[/color][/b]"
	text += "\nHas a [b][color=red]" + str(pow(2, upgradeAmount)) + "[/color][/b] times higher change to appear"
	return text
