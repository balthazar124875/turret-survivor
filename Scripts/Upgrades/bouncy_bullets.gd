extends PassiveUpgrade

var someUpgrade: bool = false

@export var bouncePercentage: float = 0.1
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
	bullet.bounce += bouncePercentage
	pass

func apply_level_up():
	if(upgradeAmount == 10):
		someUpgrade = true
		return
	
	bouncePercentage += 0.1
