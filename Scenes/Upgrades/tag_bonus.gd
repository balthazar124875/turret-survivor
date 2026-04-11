extends Node
class_name TagBonus

var tag: Upgrade.TAGS
var mult: float

func _init(tag: Upgrade.TAGS, multiplier: float):
	tag = tag
	mult = multiplier
