extends Node

class_name ShopManager;

class ShopUpgradeButton:
	var button : Control;
	var upgradeNode: Node2D;
	var tooltip : String;
	var cost: int;
	var sale: bool;
	var locked: bool;
	
static var UPGRADES_LIST = [[],[],[],[],[]]; #2D array, access elems by UPGRADE_LIST[rarity] -> gives the list of upgrades
static var availableUpgradesList : Array = []; #This list will hold all upgrades that are available to use currently CURRENTLY UNUSED!!!

#Rarity rates (rarity rate for common is always one minus the sum of the vars)
static var legendaryRate = 0.03;
static var rareRate = 0.1;
static var uncommonRate = 0.25;
static var commonRate = 1.0 - (uncommonRate + rareRate + legendaryRate);

static var commonCost = 10
static var unCommonCost = 25
static var rareCost = 50
static var legendaryCost = 150

static var shopUpgradeButtons : Array[ShopUpgradeButton] = [];

var base_reroll_cost = 2
var current_reroll_cost = base_reroll_cost

var empty_item_slot_texture: Texture2D

var buttons: Array[Node]
var locked_buyable = [2, 6]
var locked = [3, 7]

var doubles: float = 0

var freeze_limit = 1
var frozen = []

@export var sale_chance: float = 0.05
@export var super_shop_chance: float = 0.005
@export var weapon_variaty_chance: float = 0.05

@export var upgrades_scenes : Array[PackedScene] = []

var player: Player
var circle: Circle

@onready var tooltipMgr : TooltipManager = get_node("/root/EmilScene/GameplayUi/Tooltip")
var currTooltipShotButtonIdx;

@onready var doubleBuyLabel : RichTextLabel = $"../DoubleBuyLabel";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currTooltipShotButtonIdx = -1;
	player = get_node("/root/EmilScene/Player")
	circle = player.get_node("./Circle")
	load_upgrades()
	initialize_buttons()
	fillShopUpgradeButtons()
	SignalBus.current_wave_updated.connect(new_wave_shop_reroll)
	SignalBus.refresh_shop_upgrades.connect(fillShopUpgradeButtons)
	empty_item_slot_texture = load("res://Assets/Sprites/upgrades/empty_upgrade_slot.png")

func _input(event):
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_SPACE:
			_on_reroll_button_pressed()
		if event.keycode == KEY_K:
			for i in locked:
				shopUpgradeButtons[i].button.get_node("LockButton").queue_free()
			locked.clear()
			for i in locked_buyable:
				shopUpgradeButtons[i].button.get_node("LockButton").queue_free()
			locked_buyable.clear()

func load_upgrades() -> void:
	for scene in upgrades_scenes:
		var upgrade = scene.instantiate()
		
		upgrade.gold_cost = get_cost(upgrade.rarity)
		UPGRADES_LIST[upgrade.rarity].push_back(upgrade);
	
	
	#var folders = ["Circle", "Stats", "Weapons", "Passives", "Other", "Augments"]
	#for f in folders:
		#var dir = DirAccess.open("res://Scenes/Upgrades/" + f);
		#if dir:
			#dir.list_dir_begin()
			#var file_name = dir.get_next()
			#while file_name != "":
				#var upgrade = load("res://Scenes/Upgrades/" + f  + "/" + file_name).instantiate()
				#upgrade.gold_cost = get_cost(upgrade.rarity)
				#UPGRADES_LIST[upgrade.rarity].push_back(upgrade);
				#file_name = dir.get_next()
				#
				#if(f == "Circle"):
					#upgrade._instantiate(); #Generate random inner outer functionality for circle upgrade
		#else:
			#print("An error occurred when trying to access the path.");
						
func initialize_buttons() -> void:
	buttons = self.get_children()
	for i in len(buttons):
		var node = ShopUpgradeButton.new()
		node.button = buttons[i]
		shopUpgradeButtons.push_back(node);
		buttons[i].button_down.connect(_on_shop_upgrade_button_pressed.bind(i))
		#Register on mouse enter and exit events for all shopbuttons
		buttons[i].mouse_entered.connect(mouse_enter.bind(i))
		buttons[i].mouse_exited.connect(mouse_exit)
		if(i in locked or i in locked_buyable):
			var l = buttons[i].get_node("LockButton")
			l.button_down.connect(_on_shop_locked_button_pressed.bind(i))
			l.mouse_entered.connect(mouse_enter.bind(i))
			l.mouse_exited.connect(mouse_exit)

func new_wave_shop_reroll(current_wave: int = 0) -> void:
	SignalBus.animate_shop_upgrade_door.emit()
	current_reroll_cost = base_reroll_cost

#Call this on re-rolls to update all shopUpgrade buttons.
func fillShopUpgradeButtons(current_wave: int = 0) -> void:
	SignalBus.shop_refreshed.emit()
	#TODO: Shuffle the upgrade list here from GameManager
	
	var s_r = randf_range(0, 1)
	var super_shop = s_r < super_shop_chance
		
	var newUpgradeList = GenerateUpgradesListForShop(1 if super_shop else shopUpgradeButtons.size());
	for i in newUpgradeList:
		if(i is WeaponUpgrade && i.upgradeAmount == 0 && i.viable_variations.size() > 0):
			if(randf() < weapon_variaty_chance):
				i.apply_variation(i.viable_variations[randi() % i.viable_variations.size()])
			else:
				i.apply_variation(GlobalEnums.WEAPON_VARIATION.NONE)
	
	for i in shopUpgradeButtons.size():
		var index = i if !super_shop else 0
		
		if(shopUpgradeButtons[i].locked):
			continue
		shopUpgradeButtons[i].upgradeNode = newUpgradeList[index];
		buttons[i].texture_normal = newUpgradeList[index].icon
		var r = randf_range(0, 1)
		var x = shopUpgradeButtons[i]
		var sale = (r < sale_chance + (player.luck * 0.01))
		shopUpgradeButtons[i].sale = sale
		shopUpgradeButtons[i].button.get_node("Sale").visible = sale
		shopUpgradeButtons[i].cost = newUpgradeList[index].gold_cost * (0.5 if sale else 1)
		
		if(newUpgradeList[index] is WeaponUpgrade && newUpgradeList[index].variation != GlobalEnums.WEAPON_VARIATION.NONE):
			buttons[i].get_node("ExtraInfo").text = IconHandler.get_icon_path(GlobalEnums.WEAPON_VARIATION_NAMES[newUpgradeList[index].variation])
		else:
			buttons[i].get_node("ExtraInfo").text = ""
			
		GenerateButtonTooltip(shopUpgradeButtons[i]);
		var text = buttons[i].get_child(0) as RichTextLabel
		text.scroll_active = false
		if(newUpgradeList[i if !super_shop else 0].upgradeAmount != 0):
			text.text = "[right][color=black][font_size=12]" + str(newUpgradeList[i if !super_shop else 0].upgradeAmount) + "[/font_size][/color][/right]"
		else:
			text.text = ""
		
		var outline = buttons[i].get_child(1)
		outline.update(sale, get_color(newUpgradeList[i if !super_shop else 0].rarity))
			
		UpdateUpgradeTooltip(currTooltipShotButtonIdx);
		
			

func GenerateButtonTooltip(shopUpgradeButtons : ShopUpgradeButton) -> void:
	shopUpgradeButtons.tooltip = str(
			"[b]",
			shopUpgradeButtons.upgradeNode.upgradeName,
			"[/b]",
			"\n", 
			shopUpgradeButtons.upgradeNode.description,
			"\n"
		)
		
	shopUpgradeButtons.tooltip += shopUpgradeButtons.upgradeNode.GetSpecialTooltipDescription(); #TODO: Implement
	shopUpgradeButtons.tooltip += shopUpgradeButtons.upgradeNode.GetTooltipStats();
	shopUpgradeButtons.tooltip += str(shopUpgradeButtons.cost, IconHandler.get_icon_path("coin"))

func buy_upgrade(index: int) -> void:
	player.modify_gold(-shopUpgradeButtons[index].cost)
	var new_upgrade = shopUpgradeButtons[index].upgradeNode.duplicate()
	add_child(new_upgrade)
	#Player upgrader
	shopUpgradeButtons[index].upgradeNode.applyPlayerUpgrade(player)
		
	if(doubles > 0):
		shopUpgradeButtons[index].upgradeNode.applyPlayerUpgrade(player)
		update_doubles(-1)
	pass

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
	if Input.is_mouse_button_pressed(2):
		lock_item(index)
		return
		
	if shopUpgradeButtons[index].upgradeNode == null:
		return
		
	if player.gold < shopUpgradeButtons[index].cost:
		return
		
	buy_upgrade(index)

	var x = shopUpgradeButtons[index]
	
	shopUpgradeButtons[index].upgradeNode = null
	shopUpgradeButtons[index].locked = false
	shopUpgradeButtons[index].button.get_node("FROZEN").visible = shopUpgradeButtons[index].locked
	buttons[index].texture_normal = empty_item_slot_texture
	tooltipMgr.HideTooltip();
	
func lock_item(index: int) -> void:
	if (!shopUpgradeButtons[index].locked):
		var locked_amount = shopUpgradeButtons.reduce(func(a, b): return a +  (1 if b.locked else 0), 0)
		if(locked_amount >= freeze_limit):
			return
	
	shopUpgradeButtons[index].locked = !shopUpgradeButtons[index].locked
	shopUpgradeButtons[index].button.get_node("FROZEN").visible = shopUpgradeButtons[index].locked

func _on_shop_locked_button_pressed(index: int) -> void:
	if(index in locked_buyable):
		var unlock_cost = (100 if locked_buyable.size() == 2 else 300)
		if(player.gold >= unlock_cost):
			shopUpgradeButtons[index].button.get_node("LockButton").queue_free()
			locked_buyable.erase(index)
			player.modify_gold(-unlock_cost)
		return

func _on_reroll_button_pressed() -> void:
	if player.gold < current_reroll_cost:
		return
	player.modify_gold(-current_reroll_cost)
	current_reroll_cost += 1
	SignalBus.animate_shop_upgrade_door.emit()

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
			return Color(0, 0.75, 0)
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
	
	if(index in locked_buyable):
		tooltipMgr.DisplayTooltip("Locked! Unlock for " + ("100" if locked_buyable.size() == 2 else "300") + IconHandler.get_icon_path("coin") + "?", highlightedButton);
		return
	if(index in locked ):
		tooltipMgr.DisplayTooltip("Locked! Find an augment to unlock these", highlightedButton);
		return
		
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
	
func unlock_extra_slots() -> void:
	for i in locked:
		shopUpgradeButtons[i].button.get_node("LockButton").queue_free()
	locked.clear()
	
func update_doubles(amount: float):
	doubles += amount
	doubleBuyLabel.visible = true if doubles > 0 else false
	
func get_random_upgrade() -> Upgrade:
	var flat_array = []
	for sub_array in UPGRADES_LIST:
		flat_array += sub_array  # Concatenate sub-arrays
	if flat_array.size() > 0:
		return flat_array[randi() % flat_array.size()]
	return null  # Or some fallback value if the array is empty
	
func get_random_upgrades(count: int = 10) -> Array:
	var flat_array = []

	for sub_array in UPGRADES_LIST:
		flat_array += sub_array

	flat_array.shuffle()
	return flat_array.slice(0, min(count, flat_array.size()))
	
func get_random_lootbox_upgrades() -> Upgrade:
	var r = randf_range(0, 1)
	
	if(r < 0.01): return choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.MYTHIC]);
	if(r < 0.03): return choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.LEGENDARY]);
	if(r < 0.1): return choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.RARE]);
	if(r < 0.25): return choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.UNCOMMON]);
	return choose_weighted_random(UPGRADES_LIST[Upgrade.UpgradeRarity.COMMON]);
