#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

"""
	TUTORIAL! How to create new upgrades!
	1. Create the upgrade class file.
	2. Increment the variable NUMBER_OF_UPGRADES.
	3. Put it in _ready function!
"""

var UPGRADES_LIST : Array = [];
const NUMBER_OF_UPGRADES = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Iterate all Upgrade scripts and put them in the global array
	var dir = DirAccess.open("Upgrades/");
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				UPGRADES_LIST.push_back(load("Upgrades/" + file_name).new())
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
