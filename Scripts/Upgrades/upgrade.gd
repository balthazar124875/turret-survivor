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

@export var upgradeName : String;
@export var description : String;
@export var type : UpgradeType;
@export var rarity : UpgradeRarity;
@export var icon : Texture2D; #The image icon for the upgrade
@export var gold_cost = 10
var playerCosmetic; #The cosmetic this upgrade will add to your player, e.g hat, wings etc.
var learnt = false; #Set to true if this upgrade has been learnt
var upgradeAmount = 0; #If this is > 0, it means this upgrade can be chosen several times until the counter reaches 0, then you'll set learnt to true!

func applyUpgradeToPlayer() -> void:
	upgradeAmount -= 1;
	if(upgradeAmount <= 0):
		learnt = true;
	applyCosmeticChangeToPlayer();

func applyCosmeticChangeToPlayer() -> void:
	pass
