extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Push out latest bought orb"; #TODO: Write which orb that is
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	var playerOrbAmount = player.playerOrbs.size();
	if(playerOrbAmount != 0):
		var latestOrb = Player.playerOrbs[playerOrbAmount-1];
		#Delete orb from array and rearrange array.
		player.playerOrbs.remove_at(playerOrbAmount-1);
		latestOrb.orbRange *= 2.5;
		latestOrb.orbSpeed *= 0.5;
		player.playerOrbsOuter.push_back(latestOrb);
		player.ArrangePlayerOrbs(player.playerOrbs);
		player.ArrangePlayerOrbs(player.playerOrbsOuter);
		latestOrb.ApplyVisualChanges();
