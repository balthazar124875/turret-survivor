extends Node

class_name Upgrade

enum UpgradeType {
	WEAPON,
	PASSIVE,
	PLAYER_STAT_UP,
	GAME_STAT_UP,
	CIRCLE,
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
@export var weight = 10;
@export var weight_reduction: = 0
@export var rolled: bool

func applyUpgradeToPlayer(player: Player) -> void:
	learnt = true;
	applyCosmeticChangeToPlayer();

func applyUpgradeToCircle(circle: Circle) -> void:
	pass

func applyCosmeticChangeToPlayer() -> void:
	pass

func reparentToPlayer(player: Player) -> void:
	pass

func reparentToCircle(circle: Circle) -> void:
	pass

func applyPlayerUpgrade(player: Player) -> void:
	upgradeAmount += 1
	weight -= weight_reduction 
	applyUpgradeToPlayer(player)
	reparentToPlayer(player)
	
func applyCircleUpgrade(circle: Circle) -> void:
	upgradeAmount += 1
	weight -= weight_reduction
	applyUpgradeToCircle(circle)
	reparentToCircle(circle)
