#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

var UPGRADES_LIST : Array = [[]]; #2D array, access elems by UPGRADE_LIST[rarity] -> gives the list of upgrades

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Iterate all Upgrade scripts and put them in the global array
	var dir = DirAccess.open("Upgrades/");
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var upgrade = load("Upgrades/" + file_name).new();
				UPGRADES_LIST[upgrade.UpgradeRarity].push_back(upgrade);
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.");
	
	var NUMBER_OF_UPGRADES = UPGRADES_LIST.size();
	#Sort upgrades in list based on rarity.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
