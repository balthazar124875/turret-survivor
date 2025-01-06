extends Node

class_name Upgrade

enum UpgradeType {
	WEAPON,
	PASSIVE,
	PLAYER_STAT_UP,
	GAME_STAT_UP,
	count,
}

enum UpgradeRarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
}

var upgradeName : String;
var description : String;
var type : UpgradeType;
var rarity : UpgradeRarity;
var icon; #The image icon for the upgrade
var playerCosmetic; #The cosmetic this upgrade will add to your player, e.g hat, wings etc.
var learnt = false; #Set to true if this upgrade has been learnt
var upgradeAmount = 0; #If this is > 0, it means this upgrade can be chosen several times until the counter reaches 0, then you'll set learnt to true!

# Constructor
func _init(name : String):
	upgradeName = name;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func applyUpgradeToPlayer() -> void:
	upgradeAmount -= 1;
	if(upgradeAmount <= 0):
		learnt = true;
	applyCosmeticChangeToPlayer();

func applyCosmeticChangeToPlayer() -> void:
	pass
