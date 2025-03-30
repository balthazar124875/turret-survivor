extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Enhance first bought orb that's not yet enhanced"; #TODO: Write which orb that is
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.PROJECTILE_MODIFIER;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	var playerOrbAmount = OrbHandler.playerOrbs.size();
	if(playerOrbAmount != 0):
		for orb in OrbHandler.playerOrbs:
			if(!orb.isEnhanced):
				orb.EnhanceOrb();
				return;
				
	var outerOrbAmount = OrbHandler.playerOrbsOuter.size();
	if(outerOrbAmount != 0):
		for orb in OrbHandler.playerOrbsOuter:
			if(!orb.isEnhanced):
				orb.EnhanceOrb();
				return;
