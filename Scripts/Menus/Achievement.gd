extends UnlockNode

class_name Achievement

@export var icon : Texture2D; #The image icon for the Achievement

func _ready():
	description = ""

func IsConditionMet() -> bool:
	return false;
