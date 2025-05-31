class_name EnemyStatusEffectHandler

var enemy: Enemy

var ice_block_instance;

var dot_timer = Timer.new()
var dot_tick_time = 0.5 

func _init(enemy: Enemy):
	self.enemy = enemy
	enemy.add_child(dot_timer)
	dot_timer.wait_time = dot_tick_time
	dot_timer.start()
	dot_timer.timeout.connect(apply_dot_effects)
	
func apply_dot_effects():
	if(enemy.regen > 0):
		enemy.regenerateHp()
	
	# TODO: Sum dots seperately and add damage source categories for them
	var damage_from_poison = enemy.active_status_effects.filter(
			func(ase): return ase.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
		).map(func(ase): return ase.magnitude).reduce(func(a, b): return  a + b, 0)
		
	if damage_from_poison > 0:
		enemy.take_damage(damage_from_poison, 'Poison', GlobalEnums.DAMAGE_TYPES.POISON, true, false)
		
	var damage_from_burning = enemy.active_status_effects.filter(
		func(ase): return ase.type == GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING
	).map(func(ase): return ase.magnitude).reduce(func(a, b): return  a + b, 0)
		
	if damage_from_burning > 0:
		enemy.take_damage(damage_from_burning, 'Burning', GlobalEnums.DAMAGE_TYPES.FIRE, true, false)

func apply_status_effect(status_effect: EnemyStatusEffect):
	enemy.active_status_effects.append(status_effect)
	var type = status_effect.type
	if type in GlobalEnums.CROWD_CONTROL:
		status_effect.duration *= enemy.cc_effectiveness
		if(type == GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED):
			status_effect.magnitude *= enemy.cc_effectiveness
		
		if(type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN):
			if(enemy.ice_block_instance == null):
				ice_block_instance = enemy.get_node("/root/EmilScene/EffectHandler").freezeEffect.instantiate();
				enemy.add_child(ice_block_instance);
				ice_block_instance.global_position = enemy.global_position;
			status_effect.magnitude = 1;
		
		var crowd_control_effects = enemy.active_status_effects.filter(
				func(ase): return ase.type in GlobalEnums.CROWD_CONTROL
			)
			
		var highest_slow_amount = crowd_control_effects.map(func(ase): return ase.magnitude).max()
			
		if(highest_slow_amount != null):
			enemy.current_action_speed = enemy.action_speed * (1 - highest_slow_amount)
		else:
			enemy.current_action_speed = enemy.action_speed

func update_active_status_effect_durations(delta):
	for status_effect in enemy.active_status_effects:
		status_effect.duration -= delta
		if status_effect.duration <= 0:
			erase_status_effect(status_effect)

func erase_status_effect(status_effect: EnemyStatusEffect):
	enemy.active_status_effects.erase(status_effect)
	
	if(status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN && ice_block_instance != null && get_status(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN).size() == 0):
		ice_block_instance.queue_free();
		
	var type = status_effect.type
	
	if type in GlobalEnums.CROWD_CONTROL:
		var highest_slow_amount = enemy.active_status_effects.filter(
				func(ase): ase.type in GlobalEnums.CROWD_CONTROL
			).map(func(ase): ase.magnitude).min()
			
		if(highest_slow_amount != null):
			enemy.current_action_speed = enemy.action_speed * highest_slow_amount
		else:
			enemy.current_action_speed = enemy.action_speed

func get_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> Array[EnemyStatusEffect]:
	return enemy.active_status_effects.filter(func(ase): return ase.type == status)

func has_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> bool:
	return enemy.active_status_effects.any(func(ase): return ase.type == status)
