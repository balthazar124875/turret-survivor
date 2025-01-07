extends PassiveUpgrade

var explosionVFX
var initPercentage = 0.2 #10%
# Called when the node enters the scene tree for the first time.
func _init():
	explosionVFX = load("res://Scenes/vfx/vfx_explosion.tscn");
	description = str(initPercentage*100) + "% chance enemy explodes on death";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	#10% chance to initiate
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	if(rndNumber <= initPercentage):
		var explosion = explosionVFX.instantiate()
		add_child(explosion)
		explosion.global_position = enemy.global_position
