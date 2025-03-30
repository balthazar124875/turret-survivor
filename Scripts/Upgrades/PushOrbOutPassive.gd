extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Push out latest bought orb"; #TODO: Write which orb that is
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	var innerOrbAmount = OrbHandler.playerOrbs.size();
	var outerOrbAmount = OrbHandler.playerOrbsOuter.size();
	if(innerOrbAmount != 0 && outerOrbAmount < OrbHandler.maxNrOuterOrbs):
		var latestOrb = OrbHandler.playerOrbs[innerOrbAmount-1];
		#Delete orb from array and rearrange array.
		OrbHandler.playerOrbs.remove_at(innerOrbAmount-1);
		latestOrb.orbRange *= 2.5;
		latestOrb.orbSpeed *= 0.5;
		OrbHandler.playerOrbsOuter.push_back(latestOrb);
		OrbHandler.ArrangePlayerOrbs(OrbHandler.playerOrbs);
		OrbHandler.ArrangePlayerOrbs(OrbHandler.playerOrbsOuter);
		latestOrb.ApplyVisualChanges();
