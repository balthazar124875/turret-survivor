extends RigidBody2D

class_name Enemy

var damage_flash: bool = false

@export var speed = 100
@export var health = 5
@export var gold_value = 1
@export var damage: float = 1.0
var current_damage: float = damage
@export var attack_cooldown: float = 0.5
var current_attack_cooldown: float = attack_cooldown
@export var action_speed: float = 1
var current_action_speed: float = action_speed

var t : float

# StatusEffectType -> StatusEffect
var active_status_effects: Dictionary = {}

#var can_attack: bool = true
var target_position = Vector2.ZERO

signal enemy_killed(enemy)

var player

var damage_flash_timer = Timer.new()

func init_damage_flash_timer():
	add_child(damage_flash_timer)  # Add the Timer to the node tree
	damage_flash_timer.wait_time = 0.2  # Set duration
	damage_flash_timer.one_shot = true  # Make it auto-stop
	damage_flash_timer.timeout.connect(_on_damage_flash_timeout)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_damage_flash_timer()
	player = get_node("/root/EmilScene/Player")
	target_position = player.global_position

func apply_status_effect(status_effect: EnemyStatusEffect):
	# Add status effect if it does not exist
	if status_effect.type not in active_status_effects:
		active_status_effects[status_effect.type] = status_effect

	# Update status effect if it already exists
	if status_effect.type in active_status_effects:
		active_status_effects[status_effect.type].duration = status_effect.duration
		if status_effect.magnitude > active_status_effects[status_effect.type].magnitude:
			active_status_effects[status_effect.type].magnitude = status_effect.magnitude

func update_active_status_effects(delta):
	for type in active_status_effects.keys():
		active_status_effects[type].duration -= delta
		if active_status_effects[type].duration <= 0:
			active_status_effects.erase(type)
			
func increase_hp(multiplier: float) -> void:
	health *= multiplier


# TODO: DO NOT DO THIS EVERY FRAME
func handle_status_effects():
	current_action_speed = action_speed
	$Sprite2D.modulate = Color(1, 1, 1)
	for status_effect in active_status_effects.values():
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED:
			current_action_speed = action_speed - active_status_effects[status_effect.type].magnitude
			$Sprite2D.modulate = Color(0, 0.5, 0.5)
		if status_effect.type == GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN:
			current_action_speed = 0
			$Sprite2D.modulate = Color(0, 0, 1)
			
	# TODO: Move this, but this sets the color to red while being damaged
	if damage_flash: 
		$Sprite2D.modulate = Color(1, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * current_action_speed
	update_active_status_effects(delta)
	handle_status_effects()
	
	if(current_action_speed == 0):
		pass #frozen
	
	var current_position = global_position
	var direction = (target_position - current_position).normalized()
	# Move towards the target position
	if current_position.distance_to(target_position) > 50:  # Adjust tolerance as needed
		global_position += direction * speed * delta * current_action_speed
	elif t > attack_cooldown: 
		t = 0
		player.take_damage(damage, self)
		#call_deferred("enable_can_attack", attack_cooldown)
		#can_attack = false

#func enable_can_attack(timeout):
	#await get_tree().create_timer(timeout).timeout
	#can_attack = true

func is_alive() -> bool:
	return health > 0

func take_damage(amount: float) -> void:
	health -= amount
	damage_flash = true
	damage_flash_timer.start(0.1) 
	if(health <= 0):
		die()

func _on_damage_flash_timeout():
	damage_flash = false

func die() -> void:
	SignalBus.enemy_killed.emit(self)
	queue_free()
