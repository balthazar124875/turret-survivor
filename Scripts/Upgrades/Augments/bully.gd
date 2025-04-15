extends AugmentUpgrade

@export var damage: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_displaced.connect(on_enemy_displaced)
	pass # Replace with function body.

func on_enemy_displaced(enemy: Enemy):
	enemy.take_damage(enemy.max_health * damage, "Bully", GlobalEnums.DAMAGE_TYPES.MAGIC, true)
