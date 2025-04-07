extends PassiveUpgrade

@export var bonusOnePiercePercentage: float = 0.5

var active = false
var pierceBonus = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.bullet_created.connect(_apply_effects)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(bullet: Bullet):
	bullet.pierce += pierceBonus

func apply_level_up():
	if(upgradeAmount == 10):
		#something cool
		return
	
	pierceBonus = pierceBonus + 1
