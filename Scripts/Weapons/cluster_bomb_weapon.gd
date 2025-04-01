extends BaseGun

class_name ClusterBomb

@export var cluster_times: int = 1
		
func shoot(enemy: Node) -> void:	
	if player.global_position.distance_to(get_target().global_position) > range * player.rangeMultiplier:
		return
	var bullet = bullet.instantiate()
	if get_target() != null:
		bullet.target_pos = get_target().global_position - player.global_position
	bullet.speed = base_projectile_speed
	bullet.damage = damage * player.damageMultiplier
	bullet.cluster_times = cluster_times + player.extraChains
	bullet.number_of_cluster_bombs = base_projectile_amount + player.extraProjectiles
	add_child(bullet)

	#var bulletAmount: int = base_projectile_amount
	#var random_offset = randf_range(0, 2 * PI) 
	#for i in bulletAmount:
		#var speed = base_projectile_speed * player.projectileSpeedMultipler
		#var offset = Vector2(cos(random_offset + i * (2 * PI / bulletAmount)), sin(random_offset + i * (2 * PI / bulletAmount)))
		#bullet.init_with_direction(offset, damage, base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time)
		#bullet.rotation_speed = speed
		#bullet.outward_speed = speed / 2
		#bullet.pierce = pierce
		#bullet.life_time = bullet_life_time
		#bullet.scale = Vector2(1, 1) * player.areaSizeMultiplier
		#add_child(bullet)
	
func apply_level_up():
	if(level == 5):
			base_projectile_amount += 2
			return
	if(level == 10):
			cluster_times += 1
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
