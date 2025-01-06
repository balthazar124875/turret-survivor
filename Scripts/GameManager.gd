#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

class_name GameManager

static var UPGRADES_LIST = [[]]; #2D array, access elems by UPGRADE_LIST[rarity] -> gives the list of upgrades
static var availableUpgradesList : Array = []; #This list will hold all upgrades that are available to use currently CURRENTLY UNUSED!!!
static var shuffledUpgradesList = [[]];

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	##Iterate all Upgrade scripts and put them in the global array
	#var dir = DirAccess.open("res://Scripts/Upgrades/");
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#var upgrade = load("res://Scripts/Upgrades/" + file_name).new();
			#UPGRADES_LIST[upgrade.rarity].push_back(upgrade);
			#file_name = dir.get_next()
	#else:
		#print("An error occurred when trying to access the path.");
	#
	#var NUMBER_OF_UPGRADES = UPGRADES_LIST.size();
	#GenerateAvailableUpgradesList(); 
	#ShuffleEntireUpgradesList(); #Use a new list for this.
	#UIManager.initializeUIManager();

func GenerateAvailableUpgradesList() -> void:
	pass
	
func ShuffleEntireUpgradesList() -> void:
	#TODO: shuffle properly
	shuffledUpgradesList = UPGRADES_LIST;
	pass

#Rarity rates (rarity rate for common is always one minus the sum of the vars)
static var legendaryRate = 0.01;
static var rareRate = 0.1;
static var uncommonRate = 0.2;
static var commonRate = 1.0 - (uncommonRate + rareRate + legendaryRate);

#Put upgrades in list based on rarity.
static func GenerateUpgradesListForShop(size : int) -> Array:
	var shopUpgradeList : Array[Upgrade] = [];
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
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.LEGENDARY][0]);
		elif(randomNumber < rare):
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.RARE][0]);
		elif(randomNumber < uncommon):
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.UNCOMMON][0]);
		else:
			shopUpgradeList.push_back(shuffledUpgradesList[Upgrade.UpgradeRarity.COMMON][0]);
		
	return shopUpgradeList;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
