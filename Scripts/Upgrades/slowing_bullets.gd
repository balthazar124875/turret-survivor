extends PassiveUpgrade

@export var initPercentage = 1 #10%
@export var slowAmount = 0.5 #10%
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	SignalBus.on_enemy_hit.connect(_apply_effects)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(enemy: Enemy):
	var rng = RandomNumberGenerator.new()
	var rndNumber = rng.randf_range(0.0, 1.0);
	if(initPercentage > rndNumber):
		enemy.slow(slowAmount)
