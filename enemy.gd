extends RigidBody2D
var speed = 100
var target_position = Vector2.ZERO


func _init():
	print("Enemy _init() called")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_node("../Player")
	target_position = player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_position = global_position
	var direction = (target_position - current_position).normalized()
	# Move towards the target position
	if current_position.distance_to(target_position) > 50:  # Adjust tolerance as needed
		global_position += direction * speed * delta
	else:
		print("Enemy should be doing damage now.")
	pass
