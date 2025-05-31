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
@export var rotational_speed = 0
@export var random_shake_movement_enabled = false
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
var alive_time: float = 0.0
var isDead : bool = false;

var on_death_particles = preload("res://Scenes/Particles/TestParticle.tscn")
var damage_taken_particles = preload("res://Scenes/Particles/OnHitParticle.tscn")

var objectObstructingEnemy : Node2D = null;

@onready var movement_handler = EnemyMovementHandler.new(self)
@onready var status_effect_handler = EnemyStatusEffectHandler.new(self)
@onready var attack_handler = EnemyAttackHandler.new(self)

func init_timers():
	add_child(damage_flash_timer)  # Add the Timer to the node tree
	damage_flash_timer.wait_time = 0.2  # Set duration
	damage_flash_timer.one_shot = true  # Make it auto-stop
	damage_flash_timer.timeout.connect(_on_damage_flash_timeout)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_timers()
	player = get_node("/root/EmilScene/Player")
	circle = player.get_node("./Circle")
	target_position = player.global_position
	
func add_displacement(displacement_vector: Vector2, speed: float) -> void:
	movement_handler.add_displacement(displacement_vector, speed)

func apply_status_effect(status_effect: EnemyStatusEffect):
	status_effect_handler.apply_status_effect(status_effect)

func has_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> bool:
	return status_effect_handler.has_status(status)

func get_status(status: GlobalEnums.ENEMY_STATUS_EFFECTS) -> Array[EnemyStatusEffect]:
	return active_status_effects.filter(func(ase): return ase.type == status)

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
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED:
			color = Color(0, 0.85, 0, 1)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED:
			color = Color(0.2, 0.70, 0.2, 1)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING:
			color = Color(0.7, 0.4, 0.1, 1)
			
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
	status_effect_handler.update_active_status_effect_durations(delta)
	handle_color_change()
	
	if(current_action_speed == 0):
		return #frozen / rooted
		
	# Wobble enemy sprite
	$Sprite2D.rotation_degrees = sin(alive_time * 6.0) * 7
	movement_handler.handle_movement(delta)

func is_alive() -> bool:
	return health > 0

func take_hit(amount: float,
	source: String = '',
	damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL,
	on_hit_effects: Array[EnemyStatusEffect] = [],
	ignore_armor: bool = false) -> void:
		var hit = Hit.new(amount, damage_type, on_hit_effects, source)
		SignalBus.before_enemy_take_hit.emit(hit, self)
		take_damage(hit.amount + hit.bonus_damage, source, hit.type, ignore_armor, true)
		if(!isDead):
			for on_hit_effect in hit.on_hit_effects:
				apply_status_effect(on_hit_effect)
				
			for after_hit_effect in hit.after_hit_effects:
				after_hit_effect.call(self)

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
	
	SignalBus.damage_done.emit(self, damage_done, damage_type, source, direct)
	
	if(health <= 0 && !isDead):
		die()
	else:
		start_damage_flash()

func start_damage_flash():
	if(!damage_flash):
		spawn_one_shot_particles(damage_taken_particles, self.global_position)
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
