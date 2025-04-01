extends PassiveUpgrade

@export var max_health_removed: float = 500
@export var gold_gained: float = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	player.modify_gold(500)
	player.modify_max_health(-500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(bullet: Bullet):
	pass
