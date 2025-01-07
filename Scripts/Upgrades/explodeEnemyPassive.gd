extends PassiveUpgrade

var explosionVFX

# Called when the node enters the scene tree for the first time.
func _init():
	explosionVFX = load("res://Scenes/vfx/vfx_explosion.tscn");
	description = "10% chance enemy explodes on death";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	var explosion = explosionVFX.instantiate()
	add_child(explosion)
	explosion.global_position = enemy.global_position
	pass
