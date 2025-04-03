extends BaseGun

class_name DiscLauncher

func shoot(enemy: Node) -> void:	
	var bulletAmount: int = base_projectile_amount + player.extraProjectiles
	var random_offset = randf_range(0, 2 * PI) 
	for i in bulletAmount:
		var bullet = bullet.instantiate()
		var speed = base_projectile_speed * player.projectileSpeedMultipler
		var offset = Vector2(cos(random_offset + i * (2 * PI / bulletAmount)), sin(random_offset + i * (2 * PI / bulletAmount)))
		bullet.init_with_direction(offset, damage * player.damageMultiplier, base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time, "Disc Launcher")
		bullet.rotation_speed = speed
		bullet.outward_speed = speed / 2
			
			
			
		bullet.pierce = pierce
		bullet.life_time = bullet_life_time
		bullet.scale = Vector2(1, 1) * player.areaSizeMultiplier
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
