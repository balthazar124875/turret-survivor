extends PassiveUpgrade

# Called when the node enters the scene tree for the first time.
func _init():
	description = "Enhance all your orbs";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.PROJECTILE_MODIFIER;
	rarity = UpgradeRarity.COMMON;

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player);
	if(upgradeAmount == 1):
		#Level 1 here
		OrbHandler.LevelUpOrbs(upgradeAmount);

func apply_level_up():
	OrbHandler.LevelUpOrbs(upgradeAmount);
