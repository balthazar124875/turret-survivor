extends ArcProjectile

class_name Trap

var base_damage = 1
var armed = false
var lifetime

func _on_body_entered(body):
	if body is Enemy:  # Replace with your enemy script class name
		trigger_trap()

func trigger_trap():
	queue_free()

func create_trap(start_pos: Vector2, target_pos: Vector2, speed: float, damage: float, scale: float):
	init_arc(start_pos, target_pos, speed)
	base_damage = damage
	self.scale *= scale

func land():
	landed = true
	armed = true
	connect("body_entered", _on_body_entered)
	
	for body in get_overlapping_bodies():
		if body is Enemy:  # Check if it's an enemy
			trigger_trap()
