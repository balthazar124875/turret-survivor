extends PassiveUpgrade

@export var bouncePercentage: float = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	super.applyUpgradeToPlayer(player)
	SignalBus.bullet_created.connect(_apply_effects)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(bullet: Bullet):
	bullet.bounce += 0.2
	pass
