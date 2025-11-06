extends PassiveUpgrade

@export var explosionVFX: PackedScene
@export var hp_scaling: float = 0.1

var initPercentage = 0.03 #10%
# Called when the node enters the scene tree for the first time.
func _init():
	explosionVFX = load("res://Scenes/vfx/vfx_explosion.tscn");
	description = str(initPercentage*100) + "% chance enemy explodes on death, doubled on burning enemies";
	type = UpgradeType.PASSIVE;
	passiveType = PassiveUpgradeType.ENEMY_KILL_TYPE;
	rarity = UpgradeRarity.COMMON;

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	#10% chance to initiate
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	
	if(enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING)):
		rndNumber *= 0.5
	
	if(rndNumber <= initPercentage):
		var explosion = explosionVFX.instantiate()
		explosion.damage = enemy.max_health * 0.1
		add_child(explosion)
		explosion.global_position = enemy.global_position

func apply_level_up():
	initPercentage += 0.03

func get_description() -> String:
	var text = "[color=red]" + str(100 * initPercentage) + "%[/color] for enemeis to explode for [color=yellow]" + str(100 * hp_scaling) + "%[/color] of their health as fire damage to nearby enemies. Burning enemies have a double chance"

	return text
