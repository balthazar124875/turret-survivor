extends Area2D

class_name Bullet

var speed = 300
var direction: Vector2
var damage: float
var life_time: float = 3

#behaviour modifiers
var pierce: int = 4
var bounce: float = 0

var dist
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	SignalBus.bullet_created.emit(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func init_with_target(target: Node, damage: float, speed: float, life_time: float) -> void:
	var current_position = global_position
	direction = (target.position - current_position).normalized()
	self.damage = damage
	self.life_time = life_time
	self.speed = speed
	call_deferred("_delete_after_time", life_time)
	
func init_with_direction(direction: Vector2, damage: float, speed: float, life_time: float) -> void:
	self.direction = direction
	self.damage = damage
	self.life_time = life_time
	self.speed = speed
	self.rotation = direction.angle()
	call_deferred("_delete_after_time", life_time)

func HitEnemy(body : Enemy):
	body.take_damage(damage)  # Call the enemy's damage function
	SignalBus.on_enemy_hit.emit(body)

func _on_body_entered(body):
	if body is Enemy:  # Replace with your enemy script class name
		
		HitEnemy(body)
		if(pierce > 1):
			pierce -= 1;
			return
		
		if(pierce == 0 && bounce == 0):
			queue_free()  # Destroy the bullet
			return
			
		var rng = RandomNumberGenerator.new()
		var rndNumber = rng.randf_range(0.0, 1);
		if(bounce > rndNumber):
			direction = direction.rotated(180 + deg_to_rad(rng.randf_range(-90, 90)))
			self.rotation = direction.angle()
		else:
			queue_free()
		
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	queue_free()
