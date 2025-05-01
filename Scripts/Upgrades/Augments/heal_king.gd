extends AugmentUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var heal_bonus: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.healing_multiplier += heal_bonus
	pass # Replace with function body.
	
