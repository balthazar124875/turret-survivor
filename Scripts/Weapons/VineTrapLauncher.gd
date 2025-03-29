extends BaseGun

class_name VineTrapLauncher

func shoot_area(position: Vector2) -> void:
	var trap = bullet.instantiate()
	add_child(trap)
	trap.global_position = position
