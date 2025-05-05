extends Node

func get_luck_scaling_format(procChance: float, luckScaling: float, luck: float) -> String:
	return "[color=red]" + str(100 * (procChance * (1 + (luck * luckScaling)))) + "%[/color](" + str(procChance * 100) + "+" + str(procChance * luckScaling * 100) + "*" + IconHandler.get_icon_path("luck") + ")"
