extends RigidBody2D

class_name Enemy

var speed = 100
var target_position = Vector2.ZERO
var health = 5
var gold_value = 1

signal enemy_killed(enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_node("/root/EmilScene/Player")
	target_position = player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_position = global_position
	var direction = (target_position - current_position).normalized()
	# Move towards the target position
	if current_position.distance_to(target_position) > 50:  # Adjust tolerance as needed
		global_position += direction * speed * delta
	#else:
		#print("Enemy should be doing damage now.")
	pass

func is_alive() -> bool:
	return health > 0

func take_damage(amount: float) -> bool:
	health -= amount
	var dead = !is_alive()
	if(dead):
		die()
	return is_alive()

func die() -> void:
	SignalBus.enemy_killed.emit(self)
	queue_free()
