extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Enhance first bought orb that's not yet enhanced"; #TODO: Write which orb that is
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.PROJECTILE_MODIFIER;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
