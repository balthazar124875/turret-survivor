extends PassiveUpgrade

@export var procChance = 0.1 #10%
@export var duration = 1.0 #10%
# Called when the node enters the scene tree for the first time.
func _init():
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy) -> void:
	print("im frozen")
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	if(rndNumber <= procChance):
		var freeze = EnemyStatusEffect.new()
		freeze.type = GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN
		freeze.duration = duration
		freeze.magnitude = 0
		enemy.apply_status_effect(freeze)
