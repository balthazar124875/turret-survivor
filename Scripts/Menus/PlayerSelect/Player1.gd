extends PlayerSelectNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerName = "Player1x"
	isLocked = false;
	
	startAugments.push_back(load("res://Scenes/Upgrades/Augments/yummy_coin.tscn"));
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
