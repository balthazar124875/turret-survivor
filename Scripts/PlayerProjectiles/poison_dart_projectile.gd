extends Bullet

@export var poison_damage_per_tick: float
@export var poison_duration: float

func HitEnemy(body : Enemy):
	var poisonEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED, poison_duration, poison_damage_per_tick)
	body.take_hit(damage, source, GlobalEnums.DAMAGE_TYPES.PHYSICAL, [poisonEffect])
	SignalBus.on_enemy_hit.emit(body, self)
