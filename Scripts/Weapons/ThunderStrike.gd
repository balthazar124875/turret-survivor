extends BaseGun

class_name ThunderStrike

#TODO: Get random area around player
func get_target_area() -> Vector2: #defaults to getting closest
	return player.global_position
	
#TODO: Spawn lighting strike!
func shoot_area(position: Vector2) -> void:
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.global_position = position
	pass
