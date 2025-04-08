extends Bullet

@export var poison_damage_per_tick: float
@export var poison_duration: float

func HitEnemy(body : Enemy):
	body.take_damage(damage, source)  # Call the enemy's damage function
	var poisonEffect = EnemyStatusEffect.new()
	poisonEffect.type = GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
	poisonEffect.duration = poison_duration
	poisonEffect.magnitude = poison_damage_per_tick
	body.apply_status_effect(poisonEffect)
	SignalBus.on_enemy_hit.emit(body, self)
