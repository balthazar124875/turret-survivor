extends AugmentUpgrade

var cost_reduction = 3

@onready var shop_manager: ShopManager 

func _ready() -> void:
	SignalBus.shop_refreshed.connect(shop_refreshed)
	shop_manager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")
	
func shop_refreshed() -> void:
	for upgrade in shop_manager.shopUpgradeButtons:
		if upgrade.locked:
			var reduction = min(cost_reduction, upgrade.cost)
			upgrade.cost -= reduction
			shop_manager.GenerateButtonTooltip(upgrade);

func get_description() -> String:
	return  "Frozen items in the shop will have thier cost reduced by [color=yellow]" + str(cost_reduction) + "[/color]" + IconHandler.get_icon_path("coin") + " when shop is refreshed"
