extends BaseGun

class_name ThunderStrike

#TODO: Get random screen position
func get_target_area() -> Vector2:
	var screenSize = get_viewport().get_visible_rect().size;
	var rng = RandomNumberGenerator.new()
	var playerPos = player.global_position
	var xOffset = 0.0#abs(playerPos.x - screenSize.y) * 0.8;
	var rndX = rng.randi_range(playerPos.x - screenSize.y/2.0 + xOffset, playerPos.x + screenSize.y/2.0 - xOffset)
	var rndY = rng.randi_range(0, screenSize.y)
	var position = Vector2(rndX,rndY);
	return position
	
#TODO: Spawn lighting strike!
func shoot_area(position: Vector2) -> void:
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.global_position = position
	pass
