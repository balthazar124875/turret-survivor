extends PassiveUpgrade

@onready var shop_manager: ShopManager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")

var total_increase = 0

func reparentToPlayer(player: Player) -> void:
	super.reparentToPlayer(player)
	shop_manager.freeze_limit += 1
	total_increase += 1
	
func apply_level_up():
	shop_manager.freeze_limit += 1
	total_increase += 1

func get_description() -> String:
	return "Increased freeze limit in shop by [color=red]" + str(total_increase) + "[/color] [b](Total: [color=red]" + str(shop_manager.freeze_limit) + "[/color])[/b]"
