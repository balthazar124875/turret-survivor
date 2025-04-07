extends Bullet

class_name PortalBullet

var screen_size = 540
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if global_position.y < 0:
		scale *= 1.5
		global_position += Vector2(0, 1080)
	if global_position.y > 1080:
		scale *= 1.5
		global_position += Vector2(0, -1080)
	if global_position.x < 420:
		scale *= 1.5
		global_position += Vector2(1080, 0)
	if global_position.x > 1500:
		scale *= 1.5
		global_position += Vector2(-1080, 0)
		#global_position += 
	#or global_position.y < 0 or global_position.y > screen_size.y:
		#queue_free()
		
