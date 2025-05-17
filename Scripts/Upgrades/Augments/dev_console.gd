extends AugmentUpgrade

@onready var debug_menu = get_node("/root/EmilScene/GameplayUi/Debug")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_menu.open(true)
	pass # Replace with function body.
	
