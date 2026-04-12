extends Control

class_name UpgradeHandler

@onready var player = get_node("/root/EmilScene/Player")
@onready var gameManager : GameManager = get_node("/root/EmilScene")

@export var augment_button: PackedScene

@export var augment_scenes: Array[PackedScene] = []
var augment_list: Array[AugmentUpgrade] = []

@export var upgrade_scenes: Array[PackedScene] = []
var upgrade_list: Array[Upgrade] = []

@export var weapon_variaty_chance: float = 0.15

func _ready():
	load_augments()
	load_upgrades()
	#load_starter_upgrades()
	
func load_augments() -> void:
	for scene in augment_scenes:
		var augment = scene.instantiate()
		if(gameManager.playerInitData.startAugments.has(scene)):
			SignalBus.augment_recieved.emit(augment)
			
			augment.applyPlayerUpgrade(player)
			continue
			
		augment_list.push_back(augment)
		
func load_upgrades() -> void:
	for scene in upgrade_scenes:
		var upgrade = scene.instantiate()
		upgrade.upgradeInit()
		if(upgrade is WeaponUpgrade && gameManager.playerInitData.startWeapons.has(scene)):
			upgrade.applyPlayerUpgrade(player)
		
		upgrade_list.push_back(upgrade)
		
func roll_upgrades(amount: int, rarity: Upgrade.UpgradeRarity, tagBonuses: Dictionary[Upgrade.TAGS, float]) -> void:
	get_tree().paused = true
	get_node("ColorRect").visible = true
	
	var rarityUpgrades = upgrade_list.filter(func(x): return rarity == x.rarity)
	
	var weightedList: Dictionary[Upgrade, int] = {}
	
	for u in rarityUpgrades:
		weightedList[u] = int(u.weight * calc_tag_weights(u.tags, tagBonuses))
	
	var chosenUpgrades: Array[Upgrade] = []
	
	for i in amount:
		chosenUpgrades.push_back(choose_weighted_random(weightedList))
		
	for u in rarityUpgrades:
		u.rolled = false
	spawn_upgrade_buttons(chosenUpgrades)
	
func calc_tag_weights(tags: Array[Upgrade.TAGS], tagBonuses: Dictionary[Upgrade.TAGS, float]):
	var mult = 1
	for tag in tags:
		if(tagBonuses.has(tag)):
			mult *= tagBonuses[tag]
	return mult
		
func choose_weighted_random(upgrades: Dictionary[Upgrade, int]):
	var weapon_elegible = player.has_room_for_weapons()
	
	var unrolled_upgrades = upgrades.keys().filter(func(x): return !x.rolled && (weapon_elegible || x is not WeaponUpgrade || player.playerUpgrades.has(x)))
	
	var total_weight = 0
	for unrolled in unrolled_upgrades:
		total_weight += upgrades[unrolled]
	
	var rand_value = randf_range(0, total_weight)
	var cumulative_weight = 0.0
	
	for unrolled in unrolled_upgrades:
		cumulative_weight += upgrades[unrolled]
		if rand_value < cumulative_weight:
			unrolled.rolled = true
			return unrolled
		
	return upgrades.keys()[0]
	
func spawn_upgrade_buttons(upgrades: Array[Upgrade]):
	var startOffset = 860 + 115
	
	startOffset -= upgrades.size() * 115 
	
	for i in upgrades.size():
		var upgrade = upgrades[i]
		
		var new_upgrade = augment_button.instantiate()
		
		if(upgrade is WeaponUpgrade):
			upgrade.roll_variation(weapon_variaty_chance)
			if(upgrade.variation != GlobalEnums.WEAPON_VARIATION.NONE):
				new_upgrade.get_node("ExtraInfo").text = IconHandler.get_icon_path(GlobalEnums.WEAPON_VARIATION_NAMES[upgrade.variation], 32, 32)
				
		new_upgrade.get_node("Name").text = "[center][b][color=3f3f74]" + upgrade.upgradeName
		new_upgrade.get_node("Description").text = "[center][color=3f3f74]" + upgrade.description
		new_upgrade.get_node("Icon").texture = upgrade.icon
		new_upgrade.get_node("BackgroundColor").color = get_color(upgrade.rarity)
		new_upgrade.name = "upgrade" + str(i)
		add_child(new_upgrade)
		new_upgrade.position = Vector2(startOffset + i * 230, 420)
		new_upgrade.choice_data = upgrade
		new_upgrade.connect("choice_selected", Callable(self, "_on_choice_selected"))
		
func _on_choice_selected(choice: Upgrade):
	if(choice is AugmentUpgrade):
		SignalBus.augment_recieved.emit(choice)
	reset()
	choice.applyPlayerUpgrade(player)
	print(choice.upgradeName)

func get_color(rarity: Upgrade.UpgradeRarity) -> Color:
	match rarity:
		Upgrade.UpgradeRarity.COMMON:
			return Color(0.33, 0.33, 0.33, 0.2)
		Upgrade.UpgradeRarity.UNCOMMON:
			return Color(0, 0.75, 0, 0.2)
		Upgrade.UpgradeRarity.RARE:
			return Color(0, 0, 1, 0.2)
		Upgrade.UpgradeRarity.LEGENDARY:
			return Color(0.916, 0.617, 0.145, 0.3)
	return Color(1, 1, 1, 0)
	
func reset():
	for child in get_children():
		if "upgrade" in child.name:
			remove_child(child)
			child.queue_free()
	get_tree().paused = false
	get_node("ColorRect").visible = false

func load_starter_upgrades():
		for augment in gameManager.playerInitData.startAugments:
			var temp = augment.instantiate()
			var loaded_aug = augment_list.find(func(x): return x.name == temp.name)
			SignalBus.augment_recieved.emit(loaded_aug)
			loaded_aug.applyUpgradeToPlayer(player);
			augment_list.erase(loaded_aug)
			
		
		for weapon in gameManager.playerInitData.startWeapons:
			var temp = weapon.instantiate()
			var loaded_weapn = upgrade_list.find(func(x): return x.name == temp.name)
			loaded_weapn.applyPlayerUpgrade(self)
	
	
