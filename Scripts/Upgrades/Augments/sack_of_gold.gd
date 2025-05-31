extends AugmentUpgrade

@export var gold_amount: int = 500

func _ready() -> void:
	player.modify_gold(gold_amount);
	pass # Replace with function body.

func get_description() -> String:
	return "Recieved [color=yellow]" + String.num(gold_amount) + "[/color]" + IconHandler.get_icon_path("coin")
