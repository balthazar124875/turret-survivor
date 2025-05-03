extends AugmentUpgrade

@onready var shop_manager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")

@export var rewardBonus: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_manager.unlock_extra_slots()
	pass # Replace with function body.
	
