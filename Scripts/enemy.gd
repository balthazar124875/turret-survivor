extends RigidBody2D

class_name Enemy

@export var speed = 100
@export var health = 5
@export var gold_value = 1
@export var damage: float = 1.0
@export var attack_cooldown: float = 0.5
@export var action_speed: float = 1

var t : float

#var can_attack: bool = true
var target_position = Vector2.ZERO

signal enemy_killed(enemy)

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/EmilScene/Player")
	target_position = player.global_position
	pass # Replace with function body.

func increase_hp(multiplier: float) -> void:
	health *= multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * action_speed
	
	if(action_speed == 0):
		pass #frozen
	
	var current_position = global_position
	var direction = (target_position - current_position).normalized()
	# Move towards the target position
	if current_position.distance_to(target_position) > 50:  # Adjust tolerance as needed
		global_position += direction * speed * delta * action_speed
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
	if(health <= 0): 
		pass
	health -= amount
	if(health <= 0):
		die()

func die() -> void:
	SignalBus.enemy_killed.emit(self)
	queue_free()
	
func slow(speed: float):
	action_speed = speed
	$Sprite2D.modulate = Color(0, 0.5, 0.5)
	
func freeze(duration: float):
	action_speed = 0
	$Sprite2D.modulate = Color(0, 0, 1)
	call_deferred("thaw", duration)

func thaw(timeout):
	await get_tree().create_timer(timeout).timeout
	action_speed = 1
	$Sprite2D.modulate = Color(1, 1, 1)
