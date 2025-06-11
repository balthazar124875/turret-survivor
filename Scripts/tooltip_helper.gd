extends Node

func get_luck_scaling_format(procChance: float, luckScaling: float, luck: float) -> String:
	return "[color=red]" + str(100 * (procChance * (1 + (luck * luckScaling)))) + "%[/color](" + str(procChance * 100) + "+" + str(procChance * luckScaling * 100) + "*" + IconHandler.get_icon_path("luck") + ")"

func get_damage_type_text(damage_type: GlobalEnums.DAMAGE_TYPES) -> String:
	return "[color=" + get_damage_color(damage_type) + "]" + get_enum_name(damage_type) + "[/color]"
	
func get_damage_color(damage_type: GlobalEnums.DAMAGE_TYPES) -> String:
	match damage_type:
		GlobalEnums.DAMAGE_TYPES.PHYSICAL: 
			return "white"
		GlobalEnums.DAMAGE_TYPES.MAGIC:
			return "purple"
		GlobalEnums.DAMAGE_TYPES.ICE:
			return "cyan"
		GlobalEnums.DAMAGE_TYPES.FIRE: 
			return "red"
		GlobalEnums.DAMAGE_TYPES.POISON: 
			return "green"
		GlobalEnums.DAMAGE_TYPES.LIGHTNING: 
			return "yellow"
	return "white"
	
func get_enum_name(damage_type: GlobalEnums.DAMAGE_TYPES):
	for name in GlobalEnums.DAMAGE_TYPES.keys():
		if GlobalEnums.DAMAGE_TYPES[name] == damage_type:
			return name
	return "UNKNOWN"
