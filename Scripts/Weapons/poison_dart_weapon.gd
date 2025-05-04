extends SimpleGun

@export var poison_damage_per_tick: float = 1
@export var poison_duration: float = 2.0

func shoot(enemy: Node) -> void:
	var bulletAmount: int = base_projectile_amount + player.extraProjectiles
	
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	direction = direction.rotated(deg_to_rad(bullet_spread * (bulletAmount / 2)))
	for n in range(bulletAmount):
		var bullet = wrapAroundBullet.instantiate() if wrapAround else bullet.instantiate()
		bullet.poison_damage_per_tick = poison_damage_per_tick
		bullet.poison_duration = poison_duration
		add_child(bullet)
		bullet.init_with_direction(direction, damage * gun_damage_multiplier, 
			base_projectile_speed * local_projectile_speed_multiplier * player.projectileSpeedMultipler, bullet_life_time, source)
		bullet.pierce += player.extraPierce
		bullet.bounce += player.extraBounce
		direction = direction.rotated(-deg_to_rad(bullet_spread))

# TODO: Add other poison level ups
func apply_level_up():
	if(level == 5):
		cooldown *= 0.8
		return
	if(level == 10):
		local_projectile_speed_multiplier *= 0.75
		bullet_life_time *= 1.33
		return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			poison_duration += 1
		4:
			poison_damage_per_tick += 1
