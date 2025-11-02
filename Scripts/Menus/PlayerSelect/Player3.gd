extends PlayerSelectNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerID = 2;
	playerName = "Flower";
	isLocked = true;
	unlockCondition = "Deal 1000 damage of each element (fire, ice, lighting, poison) in a single run."
	pass # Replace with function body.
