extends Node

var hp = 100;
var playerUpgrades : Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _addUpgrade(upgrade : Upgrade) -> void:
	playerUpgrades.push_back(upgrade);
