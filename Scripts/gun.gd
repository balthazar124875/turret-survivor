extends BaseGun

class_name SimpleGun

@export var bullet_spread: float = 10
@export var base_projectile_amount: float = 1
@export var base_projectile_speed: float = 300

func get_target() -> Node:
	var closest_enemy: Node = null
	var shortest_distance: float = INF
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance && distance < range * player.rangeMultiplier:
					shortest_distance = distance
					closest_enemy = enemy
					
	return closest_enemy

func shoot(enemy: Node) -> void:
	var bulletAmount: int = base_projectile_amount + player.extraProjectiles
	
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	direction = direction.rotated(deg_to_rad(bullet_spread * (bulletAmount / 2)))
	for n in range(bulletAmount):
		var bullet = bullet.instantiate()
		add_child(bullet)
		bullet.init_with_direction(direction, damage * player.damageMultiplier, base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time)
		direction = direction.rotated(-deg_to_rad(bullet_spread))

func apply_level_up():
	if(level == 5):
			base_projectile_amount += 2
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
