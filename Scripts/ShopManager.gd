extends Node

class_name ShopManager;

class ShopUpgradeButton:
	var button;
	var upgradeNode: Node2D;
	
static var UPGRADES_LIST = [[]]; #2D array, access elems by UPGRADE_LIST[rarity] -> gives the list of upgrades
static var availableUpgradesList : Array = []; #This list will hold all upgrades that are available to use currently CURRENTLY UNUSED!!!
static var shuffledUpgradesList = [[]];

#Rarity rates (rarity rate for common is always one minus the sum of the vars)
static var legendaryRate = 0.01;
static var rareRate = 0.1;
static var uncommonRate = 0.2;
static var commonRate = 1.0 - (uncommonRate + rareRate + legendaryRate);

static var shopUpgradeButtons : Array[ShopUpgradeButton] = [];

var base_reroll_cost = 5
var current_reroll_cost = base_reroll_cost

var empty_item_slot_texture: Texture2D

var buttons: Array[Node]

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_upgrades()
	initialize_buttons()
	SignalBus.current_wave_updated.connect(new_wave_shop_reroll)
	player = get_node("/root/EmilScene/Player")
	empty_item_slot_texture = load("res://Assets/Sprites/upgrades/empty_upgrade_slot.png")

func load_upgrades() -> void:
			#Iterate all Upgrade scripts and put them in the global array
	var folders = ["Stats", "Weapons", "Passives"]
	for f in folders:
		var dir = DirAccess.open("res://Scenes/Upgrades/" + f);
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				var upgrade = load("res://Scenes/Upgrades/" + f  + "/" + file_name).instantiate()
				UPGRADES_LIST[upgrade.rarity].push_back(upgrade);
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.");

func initialize_buttons() -> void:
	buttons = self.get_children()
	for i in len(buttons):
		var node = ShopUpgradeButton.new()
		node.button = buttons[i]
		shopUpgradeButtons.push_back(node);
		buttons[i].pressed.connect(_on_shop_upgrade_button_pressed.bind(i))
	fillShopUpgradeButtons()

func new_wave_shop_reroll(current_wave: int = 0) -> void:
	fillShopUpgradeButtons()
	current_reroll_cost = base_reroll_cost

#Call this on re-rolls to update all shopUpgrade buttons.
func fillShopUpgradeButtons(current_wave: int = 0) -> void:
	print("fill shop")
	#TODO: Shuffle the upgrade list here from GameManager
	ShuffleEntireUpgradesList()
	var newUpgradeList = GenerateUpgradesListForShop(shopUpgradeButtons.size());
	for i in shopUpgradeButtons.size():
		shopUpgradeButtons[i].upgradeNode = newUpgradeList[i];
		buttons[i].texture_normal = newUpgradeList[i].icon
		buttons[i].tooltip_text = str(
			newUpgradeList[i].upgradeName,
			"\n", 
			newUpgradeList[i].description,
			"\n", 
			newUpgradeList[i].gold_cost, 
			" gold"
		)

func renderShopUpgradeButtonsText() -> void:
	#TODO: Can't assign text to TextureButton like this.
	#solution here: 
	#for x in shopUpgradeButtons:
		#x.button.text = x.upgrade.description;
	pass
	
func ShuffleEntireUpgradesList() -> void:
	#TODO: shuffle properly
	shuffledUpgradesList = UPGRADES_LIST;
	pass

#Put upgrades in list based on rarity.
func GenerateUpgradesListForShop(size : int) -> Array:
	var shopUpgradeList : Array = [];
	#rates for this algorithm.
	var legendary = legendaryRate;
	var rare = rareRate + legendary;
	var uncommon = uncommonRate + rare;
	var common = 1.0 - uncommon;
	#Make sure none of the rates are above 1.0 (but this should never happen honestly)
	#Our upgrades will only be to increase rare drops or legendary drops by a few %.
	for i in size:
		var rng = RandomNumberGenerator.new()
		var randomNumber = 0.9; #TODO: TEMPORARY always generate comomon! #rng.randf_range(1.0, 0.0);
		if(randomNumber < legendary):
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.LEGENDARY].pick_random());
		elif(randomNumber < rare):
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.RARE].pick_random());
		elif(randomNumber < uncommon):
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.UNCOMMON].pick_random());
		else:
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.COMMON].pick_random());
		
	return shopUpgradeList;

func _on_shop_upgrade_button_pressed(index: int) -> void:
	if shopUpgradeButtons[index].upgradeNode == null:
		return
	if player.gold < shopUpgradeButtons[index].upgradeNode.gold_cost:
		return
	player.modify_gold(-shopUpgradeButtons[index].upgradeNode.gold_cost)
	var new_upgrade = shopUpgradeButtons[index].upgradeNode.duplicate()
	add_child(new_upgrade)
	new_upgrade.apply(player)
	player.playerUpgrades.push_back(new_upgrade);

	shopUpgradeButtons[index].upgradeNode = null
	buttons[index].texture_normal = empty_item_slot_texture

func _on_reroll_button_pressed() -> void:
	if player.gold < current_reroll_cost:
		return
	player.modify_gold(-current_reroll_cost)
	current_reroll_cost += base_reroll_cost
	fillShopUpgradeButtons()
