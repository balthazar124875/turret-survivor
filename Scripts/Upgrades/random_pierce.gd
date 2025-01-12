extends PassiveUpgrade

@export var bonusOnePiercePercentage: float = 0.5
var rng
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	rng = RandomNumberGenerator.new()
	SignalBus.bullet_created.connect(_apply_effects)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(bullet: Bullet):
	var rndNumber = rng.randf_range(0.0, 1);
	if(rndNumber > bonusOnePiercePercentage):
		bullet.pierce += 1
