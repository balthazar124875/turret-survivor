extends BaseGun

class_name PoisonNova

@export var particle_effect: PackedScene

func shoot(enemy: Node) -> void:	
	if player.global_position.distance_to(get_target().global_position) > range * player.rangeMultiplier:
		return
	var bullet = bullet.instantiate()
	if get_target() != null:
		bullet.target_pos = get_target().global_position - player.global_position
	bullet.speed = base_projectile_speed
	bullet.damage = damage * player.damageMultiplier * gun_damage_multiplier
	bullet.cluster_times = cluster_times + player.extraChains if recursive else cluster_times
	bullet.number_of_cluster_bombs = base_projectile_amount + player.extraProjectiles
	add_child(bullet)
	
func apply_level_up():
	if(level == 5):
			base_projectile_amount += 1
			return
	if(level == 10):
			recursive = true
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
