extends PassiveUpgrade

@export var procChance = 1.0 #10%
@export var duration = 2.0 #10%
# Called when the node enters the scene tree for the first time.
func _init():
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy) -> void:
	print("im frozen")
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	if(rndNumber <= procChance):
		enemy.freeze(duration)
