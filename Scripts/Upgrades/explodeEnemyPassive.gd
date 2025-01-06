extends PassiveUpgrade


# Called when the node enters the scene tree for the first time.
func _init():
	description = "10% chance enemy explodes on death";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	pass
