extends Enemy

class_name ExplodingEnemy

@export var explosionVFX : PackedScene

func attack() -> void:
	t = 0
	player.take_damage(damage, self)
	var explosion = explosionVFX.instantiate()
	explosion.position = position
	explosion.set_particle_scale(150)
	$CollisionShape2D.shape.radius = 1
	get_node("/root/EmilScene").add_child(explosion)
	die()
	
