extends RigidBody2D

class_name Enemy

var damage_flash: bool = false

@export var speed = 100
@export var max_health = 5
@export var health = 5
@export var gold_value = 1
@export var damage: float = 1.0
var current_damage: float = damage
@export var attack_cooldown: float = 0.5
var current_attack_cooldown: float = attack_cooldown
@export var action_speed: float = 1
var current_action_speed: float = action_speed
@export var armor: float = 0

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

var on_death_particles = preload("res://Scenes/Particles/TestParticle.tscn")
var damage_taken_particles = preload("res://Scenes/Particles/OnHitParticle.tscn")
var damage_numbers_scene = preload("res://Scenes/UI/damage_numbers.tscn")

var objectObstructingEnemy : Node2D = null;

var dot_tick_time = 0.5 

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
	# TODO: Sum dots seperately and add damage source categories for them
	var damage_from_dots = active_status_effects.filter(
			func(ase): return ase.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
		).map(func(ase): return ase.magnitude).reduce(func(a, b): return  a + b, 0)
		
	if damage_from_dots > 0:
		take_damage(damage_from_dots, 'Poison', GlobalEnums.DAMAGE_TYPES.POISON)

func apply_status_effect(status_effect: EnemyStatusEffect):
	active_status_effects.append(status_effect)
	var type = status_effect.type
	
	if type in GlobalEnums.CROWD_CONTROL:
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
	var type = status_effect.type
	
	if type in GlobalEnums.CROWD_CONTROL:
		var highest_slow_amount = active_status_effects.filter(
				func(ase): ase.type in GlobalEnums.CROWD_CONTROL
			).map(func(ase): ase.magnitude).min()
			
		if(highest_slow_amount != null):
			current_action_speed = action_speed * highest_slow_amount
		else:
			current_action_speed = action_speed

func increase_hp(multiplier: float) -> void:
	health *= multiplier
	max_health *= multiplier
	
func increase_damage(multiplier: float) -> void:
	damage *= multiplier

# TODO: DO NOT DO THIS EVERY FRAME
func handle_color_change():
	$Sprite2D.modulate = Color(1, 1, 1)
	for status_effect in active_status_effects:
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED:
			$Sprite2D.modulate = Color(0, 0.5, 0.5)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN:
			$Sprite2D.modulate = Color(0, 0, 1)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED:
			$Sprite2D.modulate = Color(0, 0.85, 0)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED:
			$Sprite2D.modulate = Color(0.2, 0.70, 0.2)
			
	# TODO: Move this, but this sets the color to red while being damaged
	if damage_flash: 
		$Sprite2D.modulate = Color(1, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	alive_time += delta
	t += delta * current_action_speed
	update_active_status_effect_durations(delta)
	handle_color_change()
	
	if(current_action_speed == 0):
		return #frozen / rooted
		
	$Sprite2D.rotation_degrees = sin(alive_time * 6.0) * 7
	
	var current_position = global_position
	var direction = (target_position - current_position).normalized()
	# Move towards the target position
	if !objectObstructingEnemy:
		if current_position.distance_to(target_position) > 100:  # Adjust tolerance as needed
			global_position += direction * speed * delta * current_action_speed
		elif t > attack_cooldown: 
			attack()
			#call_deferred("enable_can_attack", attack_cooldown)
			#can_attack = false
	elif t > attack_cooldown:
		t = 0
		objectObstructingEnemy.take_damage(damage, self)

#func enable_can_attack(timeout):
	#await get_tree().create_timer(timeout).timeout
	#can_attack = true

func attack() -> void:
	t = 0
	player.take_damage(damage, self)

func is_alive() -> bool:
	return health > 0

func take_damage(
	amount: float,
	source: String = '',
	damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL,
	ignore_armor: bool = false
	) -> void:
	# Take minimum 1 damage
	var damage_after_type_multipler = amount * player.GetDamageMultiplier(damage_type, global_position);
	var damage_after_armor = max(1, damage_after_type_multipler) if ignore_armor else max(1, damage_after_type_multipler - armor)
	health -= damage_after_armor
	damage_flash = true
	damage_flash_timer.start(0.1) 
	spawn_one_shot_particles(damage_taken_particles, self.global_position)
	var new_damage_numbers = damage_numbers_scene.instantiate()
	new_damage_numbers.global_position = position
	new_damage_numbers.number = damage_after_armor
	new_damage_numbers.damage_type = damage_type
	get_node("/root/EmilScene/ParticleNode").add_child(new_damage_numbers)
	SignalBus.damage_done.emit(damage_after_armor, source)
	if(health <= 0):
		die()

func _on_damage_flash_timeout():
	damage_flash = false

func die() -> void:
	spawn_one_shot_particles(on_death_particles, self.global_position)
	SignalBus.enemy_killed.emit(self)
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
