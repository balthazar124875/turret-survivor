extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Increase max number of orbs"; #TODO: Write the increase amount
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.PROJECTILE_MODIFIER;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	OrbHandler.maxNrInnerOrbs += 2;
	OrbHandler.maxNrOuterOrbs += 1; #TODO: Too good, increase outer by 1 per every other level
	SignalBus.orb_amount_increased.emit(OrbHandler.playerOrbs.size(), OrbHandler.maxNrInnerOrbs, OrbHandler.playerOrbsOuter.size(), OrbHandler.maxNrOuterOrbs)

func apply_level_up():
	#match level % 2:
		#1:
			#OrbHandler.maxNrInnerOrbs += 2;
			#OrbHandler.maxNrOuterOrbs += 0;
		#2:
			#OrbHandler.maxNrInnerOrbs += 1;
			#OrbHandler.maxNrOuterOrbs += 1;
	pass
