extends BaseGun

class_name VineWall

func shoot(enemy: Node) -> void:	
	var rng = RandomNumberGenerator.new()
	var rndAngle = rng.randf_range(1, 360)
	
	var bullet = bullet.instantiate()
	var vinePos = Vector2(cos(rndAngle), sin(rndAngle)) * 0.5 * player.global_position;
	bullet.global_position = vinePos;
	add_child(bullet)

func apply_level_up():
	if(level == 5):
			base_projectile_speed += 100
			return
	if(level == 10):
			cooldown *= 0.7
			return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			range += 25
		4:
			damage += 1
