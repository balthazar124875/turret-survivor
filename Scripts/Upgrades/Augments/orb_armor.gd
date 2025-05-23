extends AugmentUpgrade


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.orb_amount_increased.connect(increase_player_armor);
	var nrOfOrbs = OrbHandler.playerOrbs.size() + OrbHandler.playerOrbsOuter.size();
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_ARMOR, nrOfOrbs, "Orb Armor");
	pass # Replace with function body.

func increase_player_armor() -> void:
	var increment = 1;
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_ARMOR, increment, "Orb Armor");
	pass
