extends Bullet

class_name PortalBullet

var screen_size = 1080
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.y < -screen_size/2:
		speed *= 0.6
		global_position += Vector2(0, screen_size)
	if global_position.y > screen_size/2:
		speed *= 0.6
		global_position += Vector2(0, -screen_size)
	if global_position.x < -screen_size/2:
		speed *= 0.6
		global_position += Vector2(screen_size, 0)
	if global_position.x > screen_size/2:
		speed *= 0.6
		global_position += Vector2(-screen_size, 0)
		
