extends Node

class_name Upgrade

enum UpgradeType {
	WEAPON,
	PASSIVE,
	PLAYER_STAT_UP,
	GAME_STAT_UP,
	CIRCLE,
	OTHER
}

enum UpgradeRarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	MYTHIC
}

enum TAGS {
	PHYSICAL,
	FIRE,
	LIGHTNING,
	COLD,
	MAGIC,
	POISON,
	HEALTH,
	INCOME,
	WEAPON,
	TRAP
}

@export var upgradeName : String;
@export var description : String;
@export var type : UpgradeType;
@export var rarity : UpgradeRarity;
@export var icon : Texture2D; #The image icon for the upgrade
@export var gold_cost = 10
var playerCosmetic; #The cosmetic this upgrade will add to your player, e.g hat, wings etc.
var learnt = false; #Set to true if this upgrade has been learnt
var upgradeAmount = 0;
var isLocked = false; #Set this to true to make this item locked, to unlock it you'll have to fullfill an UnlockNode condition.
@export var weight = 10;
@export var weight_reduction: = 0
@export var rolled: bool
@export var tags: Array[TAGS] = []

func applyUpgradeToPlayer(player: Player) -> void:
	learnt = true;
	applyCosmeticChangeToPlayer();

func applyCosmeticChangeToPlayer() -> void:
	pass

func applyPlayerUpgrade(player: Player) -> void:
	upgradeAmount += 1
	weight -= weight_reduction 
	applyUpgradeToPlayer(player)
	SignalBus.upgrade_recieved.emit(self)

	#reparentToPlayer(player)
	
#This function should return the current level desc, and next level desc
# Lvl 2 -> 3
# Atk +10% etc
# Orb upgrades will return specialized desc where they describe which orb will be replaced etc.
func GetSpecialTooltipDescription() -> String:
	return ""

#Returns current stat info about the upgrade
# atk: 2 -> 3
# speed: 3 -> 4 etc
func GetTooltipStats() -> String:
	return ""

func get_tooltip() -> String:
	return "[b]" + upgradeName + "[/b] \n" + get_description() + get_tags()

func get_description() -> String:
	return description
	
func get_tags() -> String:
	if tags.is_empty():
		return ""
		
	var tag_names: Array[String] = []
	for tag in tags:
		tag_names.append(TAGS.keys()[int(tag)])

	return "\n[b]#" + " #".join(tag_names) + "[/b]"
