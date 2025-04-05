extends Node

class_name ShopManager;

class ShopUpgradeButton:
	var button : Control;
	var upgradeNode: Node2D;
	var tooltip : String;
	
static var UPGRADES_LIST = [[],[],[],[]]; #2D array, access elems by UPGRADE_LIST[rarity] -> gives the list of upgrades
static var availableUpgradesList : Array = []; #This list will hold all upgrades that are available to use currently CURRENTLY UNUSED!!!

#Rarity rates (rarity rate for common is always one minus the sum of the vars)
static var legendaryRate = 0.03;
static var rareRate = 0.1;
static var uncommonRate = 0.25;
static var commonRate = 1.0 - (uncommonRate + rareRate + legendaryRate);

static var commonCost = 10
static var unCommonCost = 15
static var rareCost = 25
static var legendaryCost = 50

static var shopUpgradeButtons : Array[ShopUpgradeButton] = [];

var base_reroll_cost = 5
var current_reroll_cost = base_reroll_cost

var empty_item_slot_texture: Texture2D

var buttons: Array[Node]

var player: Player
var circle: Circle

@onready var tooltipMgr : TooltipManager = $"../../../Tooltip";
var currTooltipShotButtonIdx;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currTooltipShotButtonIdx = -1;
	player = get_node("/root/EmilScene/Player")
	circle = get_node("/root/EmilScene/Circle")
	load_upgrades()
	initialize_buttons()
	SignalBus.current_wave_updated.connect(new_wave_shop_reroll)
	empty_item_slot_texture = load("res://Assets/Sprites/upgrades/empty_upgrade_slot.png")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			_on_reroll_button_pressed()

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
				upgrade.gold_cost = get_cost(upgrade.rarity)
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
		#Register on mouse enter and exit events for all shopbuttons
		buttons[i].mouse_entered.connect(mouse_enter.bind(i))
		buttons[i].mouse_exited.connect(mouse_exit)
	fillShopUpgradeButtons()

func new_wave_shop_reroll(current_wave: int = 0) -> void:
	fillShopUpgradeButtons()
	current_reroll_cost = base_reroll_cost

#Call this on re-rolls to update all shopUpgrade buttons.
func fillShopUpgradeButtons(current_wave: int = 0) -> void:
	#TODO: Shuffle the upgrade list here from GameManager
	var newUpgradeList = GenerateUpgradesListForShop(shopUpgradeButtons.size());
	for i in shopUpgradeButtons.size():
		shopUpgradeButtons[i].upgradeNode = newUpgradeList[i];
		buttons[i].texture_normal = newUpgradeList[i].icon
		GenerateButtonTooltip(shopUpgradeButtons[i]);
		var text = buttons[i].get_child(0) as RichTextLabel
		text.scroll_active = false
		if(newUpgradeList[i].upgradeAmount != 0):
			text.text = "[right][color=black][font_size=12]" + str(newUpgradeList[i].upgradeAmount) + "[/font_size][/color][/right]"
		else:
			text.text = ""
		
		
		var outline = buttons[i].get_child(1) as TextureButton
		outline.modulate = get_color(newUpgradeList[i].rarity)
		#This is to fix a bug where the tooltip from previous upgrade is showing
		#even after the upgrade have changed after timer runs out.
		UpdateUpgradeTooltip(currTooltipShotButtonIdx);
		
			

func GenerateButtonTooltip(shopUpgradeButtons : ShopUpgradeButton) -> void:
	shopUpgradeButtons.tooltip = str(
			shopUpgradeButtons.upgradeNode.upgradeName,
			"\n", 
			shopUpgradeButtons.upgradeNode.description,
			"\n", 
			shopUpgradeButtons.upgradeNode.gold_cost, 
			" gold"
		)

func renderShopUpgradeButtonsText() -> void:
	#TODO: Can't assign text to TextureButton like this.
	#solution here: 
	#for x in shopUpgradeButtons:
		#x.button.text = x.upgrade.description;
	pass

#Put upgrades in list based on rarity.
func GenerateUpgradesListForShop(size : int) -> Array:
	for u in UPGRADES_LIST:
		for u2 in u:
			u2.rolled = false
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
		var randomNumber = rng.randf_range(1.0, 0.0);
		if(randomNumber < legendary):
			shopUpgradeList.push_back(choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.LEGENDARY]));
		elif(randomNumber < rare):
			shopUpgradeList.push_back(choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.RARE]));
		elif(randomNumber < uncommon):
			shopUpgradeList.push_back(choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.UNCOMMON]));
		else:
			shopUpgradeList.push_back(choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.COMMON]));
		
	return shopUpgradeList;

func _on_shop_upgrade_button_pressed(index: int) -> void:
	if shopUpgradeButtons[index].upgradeNode == null:
		return
	if player.gold < shopUpgradeButtons[index].upgradeNode.gold_cost:
		return
	player.modify_gold(-shopUpgradeButtons[index].upgradeNode.gold_cost)
	var new_upgrade = shopUpgradeButtons[index].upgradeNode.duplicate()
	add_child(new_upgrade)
	if(new_upgrade.type == Upgrade.UpgradeType.CIRCLE):
		#Circle upgrader
		shopUpgradeButtons[index].upgradeNode.applyCircleUpgrade(circle)
		circle.circleUpgrades.push_back(circle);
	else:
		#Player upgrader
		shopUpgradeButtons[index].upgradeNode.applyPlayerUpgrade(player)
		player.playerUpgrades.push_back(new_upgrade);

	shopUpgradeButtons[index].upgradeNode = null
	buttons[index].texture_normal = empty_item_slot_texture
	tooltipMgr.HideTooltip();

func _on_reroll_button_pressed() -> void:
	if player.gold < current_reroll_cost:
		return
	player.modify_gold(-current_reroll_cost)
	current_reroll_cost += base_reroll_cost
	fillShopUpgradeButtons()

func choose_weighted_random(upgrades: Array):
	var unrolled_upgrades = upgrades.filter(func(x): return !x.rolled)
	
	var total_weight = 0
	total_weight = unrolled_upgrades.reduce(func(x,y): return x + y.weight, 0)
	
	var rand_value = randf_range(0, total_weight)
	var cumulative_weight = 0.0
	
	for i in range(unrolled_upgrades.size()):
		cumulative_weight += unrolled_upgrades[i].weight
		if rand_value < cumulative_weight:
			unrolled_upgrades[i].rolled = true
			return unrolled_upgrades[i]
		
	return upgrades[0]
	
func get_color(rarity: Upgrade.UpgradeRarity) -> Color:
	match rarity:
		Upgrade.UpgradeRarity.COMMON:
			return Color(0.33, 0.33, 0.33)
		Upgrade.UpgradeRarity.UNCOMMON:
			return Color(0, 1, 0)
		Upgrade.UpgradeRarity.RARE:
			return Color(0, 0, 1)
		Upgrade.UpgradeRarity.LEGENDARY:
			return Color(1, 0.5, 0.25)
	return Color(1, 1, 1)
	
func get_cost(rarity: Upgrade.UpgradeRarity) -> float:
	match rarity:
		Upgrade.UpgradeRarity.COMMON:
			return commonCost
		Upgrade.UpgradeRarity.UNCOMMON:
			return unCommonCost
		Upgrade.UpgradeRarity.RARE:
			return rareCost
		Upgrade.UpgradeRarity.LEGENDARY:
			return legendaryCost
	return commonCost

func UpdateUpgradeTooltip(index: int):
	if(index < 0):
		return
	if shopUpgradeButtons[index].upgradeNode == null:
		return; #This means the shop upgrade button has been purchased and is gone
	var highlightedButton = shopUpgradeButtons[index].button;
	var buttonTooltip = shopUpgradeButtons[index].tooltip;
	tooltipMgr.DisplayTooltip(buttonTooltip, highlightedButton);
	currTooltipShotButtonIdx = index;
	pass

func mouse_enter(index: int) -> void:
	UpdateUpgradeTooltip(index)
	pass

func mouse_exit() -> void:
	tooltipMgr.HideTooltip();
	currTooltipShotButtonIdx = -1;
	pass
