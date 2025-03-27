extends Bullet

#var animPlayer;

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	animPlayer = $AnimationPlayer;
#	pass # Replace with function body.

func HitEnemy(body : Enemy):
	var slow = EnemyStatusEffect.new()
	slow.type = GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN
	slow.duration = 5
	slow.magnitude = 1
	body.apply_status_effect(slow)
	body.take_damage(damage)  # Call the enemy's damage function
	SignalBus.on_enemy_hit.emit(body)
