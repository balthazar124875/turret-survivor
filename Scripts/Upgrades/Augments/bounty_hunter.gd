extends AugmentUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var rewardBonus: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.championRewardBonus += rewardBonus
	pass # Replace with function body.
	
