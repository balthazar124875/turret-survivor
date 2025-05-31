extends AugmentUpgrade

var total_gained = 0

@export var limit: int = 10
var counter = 0

func _ready() -> void:
	player.modify_stat(GlobalEnums.PLAYER_STATS.BONUS_LUCK, 2, "Lady Luck");
	total_gained += 2
	SignalBus.current_wave_updated.connect(wave_updated)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wave_updated(value: float):
	counter += 1
	if(counter >= limit):
		player.modify_stat(GlobalEnums.PLAYER_STATS.BONUS_LUCK, 1, "Lady Luck");
		counter = 0
		total_gained += 1

func get_description() -> String:
	var text =  "Gives [color=green]1[/color]+ " + IconHandler.get_icon_path("luck") + " luck every [color=red]" + str(limit) + "[/color] waves"
	text += "\n[b]Luck gained: [/b][color=green]" + str(total_gained) + "[/color]" + IconHandler.get_icon_path("luck")
	return text
