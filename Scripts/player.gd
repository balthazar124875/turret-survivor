extends Node

class_name Player

var hp = 100;
var playerUpgrades : Array = [];
var rangeMultiplier = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for playerUpgrade in playerUpgrades:
		print(playerUpgrade.name);
	pass

func _addUpgrade(upgrade : Upgrade) -> void:
	if(upgrade.UpgradeType.PLAYER_STAT_UP):
		upgrade.applyStatUpgradeToPlayer(); #Call the upgrade callback function
	playerUpgrades.push_back(upgrade);
