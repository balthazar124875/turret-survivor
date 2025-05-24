extends RigidBody2D

class_name Enemy

enum EnemyState {
	MOVE,
	ATTACK,
	DISPLACEMENT
}

var scene: PackedScene

var damage_flash: bool = false

var state: EnemyState

@export var speed = 100
@export var max_health = 5
@export var health = 5
@export var regen = 0
@export var gold_value = 1
@export var damage: float = 1.0
var current_damage: float = damage
@export var attack_cooldown: float = 0.5
var current_attack_cooldown: float = attack_cooldown
@export var action_speed: float = 1
var current_action_speed: float = action_speed
@export var armor: float = 0
@export var cc_effectiveness = 1


@export var champion_type: GlobalEnums.ENEMY_CHAMPION_TYPE = GlobalEnums.ENEMY_CHAMPION_TYPE.NONE

var t : float

# StatusEffectType -> StatusEffect
var active_status_effects: Array[EnemyStatusEffect] = []

#var can_attack: bool = true
var target_position = Vector2.ZERO

signal enemy_killed(enemy)

var player
var circle

var damage_flash_timer = Timer.new()
var dot_timer = Timer.new()
var alive_time: float = 0.0
var isDead : bool = false;

var on_death_particles = preload("res://Scenes/Particles/TestParticle.tscn")
var damage_taken_particles = preload("res://Scenes/Particles/OnHitParticle.tscn")

var objectObstructingEnemy : Node2D = null;

var dot_tick_time = 0.5 

var displacement_path: Path2D
var displacement_path_follow: PathFollow2D
var displacement_speed: float

var ice_block_instance;

func init_timers():
	add_child(damage_flash_timer)  # Add the Timer to the node tree
	damage_flash_timer.wait_time = 0.2  # Set duration
	damage_flash_timer.one_shot = true  # Make it auto-stop
	damage_flash_timer.timeout.connect(_on_damage_flash_timeout)
	
	add_child(dot_timer)
	dot_timer.wait_time = dot_tick_time
	dot_timer.start()
	dot_timer.timeout.connect(apply_dot_effects)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_timers()
	player = get_node("/root/EmilScene/Player")
	circle = player.get_node("./Circle")
	target_position = player.global_position
	
func apply_dot_effects():
	if(regen > 0):
		regenerateHp()
	
	# TODO: Sum dots seperately and add damage source categories for them
	var damage_from_poison = active_status_effects.filter(
			func(ase): return ase.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
		).map(func(ase): return ase.magnitude).reduce(func(a, b): return  a + b, 0)
		
	if damage_from_poison > 0:
		take_damage(damage_from_poison, 'Poison', GlobalEnums.DAMAGE_TYPES.POISON, true, false)
		
	var damage_from_burning = active_status_effects.filter(
		func(ase): return ase.type == GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING
	).map(func(ase): return ase.magnitude).reduce(func(a, b): return  a + b, 0)
		
	if damage_from_burning > 0:
		take_damage(damage_from_burning, 'Burning', GlobalEnums.DAMAGE_TYPES.FIRE, true, false)

func apply_status_effect(status_effect: EnemyStatusEffect):
	active_status_effects.append(status_effect)
	var type = status_effect.type
	if type in GlobalEnums.CROWD_CONTROL:
		status_effect.duration *= cc_effectiveness
		if(type == GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED):
			status_effect.magnitude *= cc_effectiveness
		
		if(type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN):
			if(ice_block_instance == null):
				ice_block_instance = get_node("/root/EmilScene/EffectHandler").freezeEffect.instantiate();
				add_child(ice_block_instance);
				ice_block_instance.global_position = self.global_position;
			status_effect.magnitude = 1;
		
		var crowd_control_effects = active_status_effects.filter(
				func(ase): return ase.type in GlobalEnums.CROWD_CONTROL
			)
			
		var highest_slow_amount = crowd_control_effects.map(func(ase): return ase.magnitude).max()
			
		if(highest_slow_amount != null):
			current_action_speed = action_speed * (1 - highest_slow_amount)
		else:
			current_action_speed = action_speed

func update_active_status_effect_durations(delta):
	for status_effect in active_status_effects:
		status_effect.duration -= delta
		if status_effect.duration <= 0:
			erase_status_effect(status_effect)

func erase_status_effect(status_effect: EnemyStatusEffect):
	active_status_effects.erase(status_effect)
	
	if(status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN && ice_block_instance != null && get_status(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN).size() == 0):
		ice_block_instance.queue_free();
		
	var type = status_effect.type
	
	if type in GlobalEnums.CROWD_CONTROL:
		var highest_slow_amount = active_status_effects.filter(
				func(ase): ase.type in GlobalEnums.CROWD_CONTROL
			).map(func(ase): ase.magnitude).min()
			
		if(highest_slow_amount != null):
			current_action_speed = action_speed * highest_slow_amount
		else:
			current_action_speed = action_speed

func modify_stats(hp_mult: float, damage_mult: float, cc_effectiveness_mult: float, speed_bonus: float) -> void:
	health *= hp_mult
	max_health *= hp_mult
	damage *= damage_mult
	cc_effectiveness *= cc_effectiveness_mult
	speed *= (1 + speed_bonus)

func regenerateHp():
	health += max_health * regen
	if(health > max_health):
		health = max_health
	#add shader

# TODO: DO NOT DO THIS EVERY FRAME
func handle_color_change():
	var color = Color(1, 1, 1, 1)
	
	for status_effect in active_status_effects:
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED:
			color = Color(0, 0.5, 0.5, 1)
		#if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN:
		#	color = Color(0, 0, 1, 1)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED:
			color = Color(0, 0.85, 0, 1)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED:
			color = Color(0.2, 0.70, 0.2, 1)
			
	# TODO: Move this, but this sets the color to red while being damaged
	if damage_flash: 
		color = Color(1, 0, 0, 1)
		
	if(champion_type != GlobalEnums.ENEMY_CHAMPION_TYPE.NONE):
		$Sprite2D.material.set_shader_parameter("inner_color", color)
	else:
		$Sprite2D.modulate = color
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	alive_time += delta
	t += delta * current_action_speed
	update_active_status_effect_durations(delta)
	handle_color_change()
	
	if(current_action_speed == 0):
		return #frozen / rooted
		
	$Sprite2D.rotation_degrees = sin(alive_time * 6.0) * 7
	
	if(state == EnemyState.DISPLACEMENT):
		move_along_path(delta)
	else:
		var current_position = global_position
		var direction = (target_position - current_position).normalized()
		# Move towards the target position
		if !objectObstructingEnemy:
			if current_position.distance_to(target_position) > 100:  # Adjust tolerance as needed
				global_position += direction * speed * delta * current_action_speed
			elif t > attack_cooldown: 
				attack()
		elif t > attack_cooldown:
			t = 0
			objectObstructingEnemy.take_damage(damage, self)

func attack() -> void:
	t = 0
	player.take_damage(damage, self)

func is_alive() -> bool:
	return health > 0

func take_hit(amount: float,
	source: String = '',
	damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL,
	on_hit_effects: Array = [],
	ignore_armor: bool = false) -> void:
		take_damage(amount, source, damage_type, ignore_armor, true)
		if(!isDead):
			SignalBus.before_enemy_take_hit.emit(amount, damage_type, on_hit_effects)
			for on_hit_effect in on_hit_effects:
				apply_status_effect(on_hit_effect)

func take_damage(
	amount: float,
	source: String = '',
	damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL,
	ignore_armor: bool = false,
	direct: bool = true
	) -> void:
	# Take minimum 1 damage
	var damage_after_type_multipler = amount * player.GetDamageMultiplier(damage_type, global_position);
	var damage_after_armor = max(1, damage_after_type_multipler) if ignore_armor else max(1, damage_after_type_multipler - armor)
	var health_before = health
	health -= damage_after_armor
	health = max(0, health)
	var damage_done = health_before - health
	
	spawn_one_shot_particles(damage_taken_particles, self.global_position)
	
	SignalBus.damage_done.emit(self, damage_done, damage_type, source, direct)
	
	if(health <= 0 && !isDead):
		die()
	else:
		start_damage_flash()
	

func start_damage_flash():
	damage_flash = true
	damage_flash_timer.start(0.1) 
	
	
func _on_damage_flash_timeout():
	damage_flash = false

func die() -> void:
	isDead = true;
	spawn_one_shot_particles(on_death_particles, self.global_position)
	SignalBus.enemy_killed.emit(self)
	
	if(champion_type == GlobalEnums.ENEMY_CHAMPION_TYPE.SPLITTING):
		var angle_degrees = 360 / 2
		for i in range(2):
			get_node("/root/EmilScene/EnemySpawner").spawn_enemy(scene, false, position + Vector2(40, 0).rotated(deg_to_rad(angle_degrees) * i))
	
	queue_free()

func spawn_one_shot_particles(particles: PackedScene, position: Vector2) -> void:
	var new_particle = particles.instantiate()
	new_particle.global_position = position
	get_node("/root/EmilScene/ParticleNode").add_child(new_particle)
	
func GetObjectObstructingEnemy() -> Node2D:
	return objectObstructingEnemy;
	
func SetObjectObstructingEnemy(object : Node2D) -> void:
	objectObstructingEnemy = object;

func get_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> Array[EnemyStatusEffect]:
	var s = active_status_effects.filter(func(ase): return ase.type == status)
	return s

func has_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> bool:
	return active_status_effects.any(func(ase): return ase.type == status)

func set_champion_type(type: GlobalEnums.ENEMY_CHAMPION_TYPE):
	champion_type = type
	match type:
		GlobalEnums.ENEMY_CHAMPION_TYPE.QUICK:
			speed *= 2.5
			$Sprite2D.scale *= 0.5
			$ShadowSprite2D.scale *= 0.5
			$ShadowSprite2D.position.y *= 0.5
		GlobalEnums.ENEMY_CHAMPION_TYPE.REGENERATING:
			regen += 0.05
		GlobalEnums.ENEMY_CHAMPION_TYPE.JUGGERNAUT:
			max_health *= 2
			health *= 2
			speed *= 0.4
			$ShadowSprite2D.scale *= 1.5
			$ShadowSprite2D.position.y *= 1.5
			$Sprite2D.scale *= 1.5
			cc_effectiveness = 0
		GlobalEnums.ENEMY_CHAMPION_TYPE.SPLITTING:
			pass

func add_displacement(displacement_vector: Vector2, speed: float) -> void:
	if(cc_effectiveness == 0 || has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED)):
		return
	
	state = EnemyState.DISPLACEMENT
	SignalBus.enemy_displaced.emit(self)
	displacement_speed = speed
	create_curve(global_position + (displacement_vector)) #reduce with cc_effectiveness?
	
func create_curve(target_pos: Vector2, arc_height = 25):
	displacement_path = Path2D.new()
	displacement_path_follow = PathFollow2D.new()
	
	var curve = Curve2D.new()
	curve.add_point(position)
	curve.add_point((position + target_pos) / 2 - Vector2(0, arc_height))  # Arc control point
	curve.add_point(target_pos)
	
	var current_pos = global_position
	
	displacement_path_follow.loop = false
	displacement_path.curve = curve
	add_child(displacement_path)
	displacement_path.add_child(displacement_path_follow)

func move_along_path(delta: float):
	if displacement_path_follow.progress_ratio >= 1:
		state = EnemyState.MOVE
		
	displacement_path_follow.progress += displacement_speed * delta
	position = displacement_path_follow.position
