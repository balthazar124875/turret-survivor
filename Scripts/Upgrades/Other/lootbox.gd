extends OtherUpgrade

@onready var shop_manager: ShopManager 
@onready var lootbox_roller: LootBoxRoller 

@onready var player = get_node("/root/EmilScene/Player")

var upgrade: Upgrade

func _ready() -> void:
	shop_manager = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/ShopUpgrades")
	lootbox_roller = get_node("/root/EmilScene/GameplayUi/Lootbox")

func apply_level_up():
	upgrade = shop_manager.get_random_lootbox_upgrades()
	var random_upgrades = shop_manager.get_random_upgrades(15)
	
	for x in random_upgrades:
		print(x.upgradeName)
	
	var array: Array[Upgrade] = []
	array.append_array(random_upgrades)
	array.append(upgrade)
	lootbox_roller.populate_upgrades(array, Callable(give_upgrade_to_player))

func give_upgrade_to_player() -> void:
	upgrade.applyPlayerUpgrade(player)
	upgradeAmount -= 1
