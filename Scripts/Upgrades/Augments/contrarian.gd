extends AugmentUpgrade

@onready var shop_manager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")

func _ready() -> void:
	shop_manager.weapon_variaty_chance += 1
	
