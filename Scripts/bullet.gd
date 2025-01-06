extends RigidBody2D

var speed = 300
var direction: Vector2
var damage: float
var life_time: float = 3

var dist
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func init_with_target(target: Node, damage: float) -> void:
	var current_position = global_position
	direction = (target.position - current_position).normalized()
	self.damage = damage
	
func init_with_direction(direction: Vector2, damage: float) -> void:
	self.direction = direction
	self.damage = damage

func _on_body_entered(body):
	if body is Enemy:  # Replace with your enemy script class name
		body.take_damage(damage)  # Call the enemy's damage function
		queue_free()  # Destroy the bullet
