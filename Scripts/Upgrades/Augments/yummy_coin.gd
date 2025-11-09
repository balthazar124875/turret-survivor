extends AugmentUpgrade

var total_gained = 0

func _ready() -> void:
	SignalBus.gold_spent.connect(gold_updated)
	pass # Replace with function body.

func gold_updated(value: float):
	if(value < 0):
		player.modify_max_health(value * -1)
		total_gained += (value * -1)

func get_description() -> String:
	var text =  "Spending " + IconHandler.get_icon_path("coin") + " will increase [color=red]maximum health[/color] that much"
	text += "\n[b]Max health gained: [/b][color=red]" + str(total_gained) + "[/color]" + IconHandler.get_icon_path("health")
	return text
