extends PlayerSelectNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerName = "Lemon";
	isLocked = false;
	
	startAugments.push_back(load("res://Scenes/Upgrades/Augments/toxic_blood.tscn"));
	startAugments.push_back(load("res://Scenes/Upgrades/Augments/high_voltage.tscn"));
	
	startWeapons.push_back(load("res://Scenes/Upgrades/Weapons/basic_sword_upgrade.tscn"));
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
