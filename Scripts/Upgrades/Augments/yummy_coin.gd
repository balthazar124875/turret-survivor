extends AugmentUpgrade

func _ready() -> void:
	SignalBus.gold_spent.connect(gold_updated)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gold_updated(value: float):
	if(value < 0):
		player.modify_max_health(value * -1)

func get_description() -> String:
	return "Spending " + IconHandler.get_icon_path("coin") + " will increase [color=red]maximum health[/color] that much"
