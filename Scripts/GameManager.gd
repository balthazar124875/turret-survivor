#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

"""
	TUTORIAL! How to create new upgrades!
	1. Create the upgrade class file.
	2. Increment the variable NUMBER_OF_UPGRADES.
	3. Put it in _ready function!
"""

var upgrades : Array = [];
const upgradeObj = preload("Upgrades/upgrades.gd");
const NUMBER_OF_UPGRADES = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrades[0] = preload("Upgrades/multishot.gd").new();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
