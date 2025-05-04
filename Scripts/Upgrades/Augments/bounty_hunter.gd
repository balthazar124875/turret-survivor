extends AugmentUpgrade
@export var rewardBonus: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.championRewardBonus += rewardBonus
	pass # Replace with function body.
	
