extends ArcProjectile

class_name PoisonBlobProjectile

func explode():
	queue_free()

func land():
	landed = true
	explode()
