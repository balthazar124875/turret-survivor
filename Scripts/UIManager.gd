#Apply this script to the root UI element

extends Node

class_name UIManager;

class ShopUpgradeButtonNode:
	var button;
	var upgrade;
	
static var shopUpgradeButtons : Array[ShopUpgradeButtonNode] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Put all shop upgrade buttons in a list here
	var shopUpgrades = get_node("/root/EmilScene/Control/ShopUpgrades");
	for x in shopUpgrades.get_children():
		var node = ShopUpgradeButtonNode.new();
		node.button = x;
		shopUpgradeButtons.push_back(node);
	pass

#Have Game manager call this in its _ready function.
static func initializeUIManager() -> void:
	fillShopUpgradeButtons();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Call this on re-rolls to update all shopUpgrade buttons.
static func fillShopUpgradeButtons() -> void:
	#TODO: Shuffle the upgrade list here from GameManager
	var newUpgradeList = GameManager.GenerateUpgradesListForShop(shopUpgradeButtons.size());
	for i in shopUpgradeButtons.size():
		shopUpgradeButtons[i].upgrade = newUpgradeList[i];
	renderShopUpgradeButtonsText();
	
static func renderShopUpgradeButtonsText() -> void:
	#TODO: Can't assign text to TextureButton like this.
	#solution here: 
	#for x in shopUpgradeButtons:
		#x.button.text = x.upgrade.description;
	pass
