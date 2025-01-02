extends Upgrade

func _init():
	description = "Range of all weapons up by 10%";
	type = UpgradeType.STATUP;
	rarity = UpgradeRarity.COMMON;
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func applyStatUpgradeToPlayer(player : Player) -> void:
	player.rangeMultiplier *= 1.1;
