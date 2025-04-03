extends PassiveUpgrade

@export var health_regeneration_per_second = 0.025

@onready var player = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.modify_health_regeneration(health_regeneration_per_second * delta)
	
func _apply_effects(bullet: Bullet):
	pass
