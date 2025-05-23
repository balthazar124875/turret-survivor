extends Bullet

#var animPlayer;

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	animPlayer = $AnimationPlayer;
#	pass # Replace with function body.

func HitEnemy(body : Enemy):
	var slow = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN, 3, 1)
	body.take_hit(damage, "Ice ball", GlobalEnums.DAMAGE_TYPES.ICE, [slow])
	SignalBus.on_enemy_hit.emit(body, self)
