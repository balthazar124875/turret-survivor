extends Bullet

#var animPlayer;

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	animPlayer = $AnimationPlayer;
#	pass # Replace with function body.

func HitEnemy(body : Enemy):
	body.slow(0.5)
	body.take_damage(damage)  # Call the enemy's damage function
	SignalBus.on_enemy_hit.emit(body)
