extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Put a random of your orbs to the outer layer and double its size";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	if(player.playerOrbs.size() != 0):
		#Pick a random orb from playerOrbs[]
		var randomOrbIdx = randi() % Player.playerOrbs.size();
		var rndOrb = Player.playerOrbs[randomOrbIdx];
		#Delete orb from array and rearrange array.
		player.playerOrbs.remove_at(randomOrbIdx);
		rndOrb.orbRange *= 2.5;
		rndOrb.orbSpeed *= 0.5;
		rndOrb.scale *= 2.0;
		player.playerOrbsOuter.push_back(rndOrb);
		player.ArrangePlayerOrbs(player.playerOrbs);
		player.ArrangePlayerOrbs(player.playerOrbsOuter);
