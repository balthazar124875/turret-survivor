extends SimpleGun

@export var cashout: bool = false

func shoot(enemy: Node) -> void:
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.init_with_direction(direction, player.gold * player.damageMultiplier * gun_damage_multiplier, 
	base_projectile_speed, bullet_life_time, source)
	bullet.pierce = pierce + player.extraPierce
	bullet.bounce = player.extraBounce
	player.modify_gold(-1)

func shoot_in_circle() -> void:
	var bulletAmount: int = 8 + player.extraProjectiles
	var direction = Vector2(1, 0)
	var spread = 360 / bulletAmount
	for n in range(bulletAmount):
		var bullet = wrapAroundBullet.instantiate() if wrapAround else bullet.instantiate()
		add_child(bullet)
		bullet.init_with_direction(direction, player.gold * player.damageMultiplier * gun_damage_multiplier, 
			base_projectile_speed * local_projectile_speed_multiplier * player.projectileSpeedMultipler, bullet_life_time, source)
		bullet.pierce += player.extraPierce
		bullet.bounce += player.extraBounce
		direction = direction.rotated(-deg_to_rad(spread))
	player.modify_gold(-1)
	
# TODO: Add other poison level ups
func apply_level_up():
	if(level == 5):
		cooldown *= 0.9
		pierce += 1
		return
	if(level == 10):
		cashout = true
		SignalBus.income_recieved.connect(shoot_in_circle)
		return
	
	match level % 5:
		1:
			base_projectile_speed += 100
		2:
			cooldown *= 0.95
		3:
			gun_damage_multiplier += 0.1
		4:
			range += 100
