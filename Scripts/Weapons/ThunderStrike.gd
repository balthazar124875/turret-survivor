extends BaseGun

class_name ThunderStrike

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.global_position = position
