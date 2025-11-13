extends Control


func _ready() -> void:
	SignalBus.reroll_cost_updated.connect(update_reroll_cost)
	pass # Replace with function body.

func update_reroll_cost(amount: int):
	$RerollButton/Cost.text = "[center][img width=16 height=16]res://Assets/icons/coin.png[/img][color=yellow]" + str(amount) + "[/color]"
