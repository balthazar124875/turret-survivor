extends BaseGun

class_name DiscLauncher

func shoot(enemy: Node) -> void:	
	var bullet = bullet.instantiate()
	var random_offset = randf()
	var speed = base_projectile_speed * player.projectileSpeedMultipler
	bullet.init_with_direction(Vector2(cos(random_offset), sin(random_offset)), damage, base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time)
	bullet.outward_speed = speed / 2
	bullet.rotation_speed = speed
	bullet.pierce = pierce
	bullet.life_time = bullet_life_time
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
