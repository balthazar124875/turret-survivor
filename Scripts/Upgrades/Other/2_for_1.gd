extends OtherUpgrade

@onready var shop_manager: ShopManager 

func _ready() -> void:
	shop_manager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")
	var x = 1

func apply_level_up():
	shop_manager.update_doubles(1)
	upgradeAmount -= 1
	pass
