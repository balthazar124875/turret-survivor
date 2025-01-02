extends BaseGun

class_name SimpleGun

func get_target() -> Node:
	var closest_enemy: Node = null
	var shortest_distance: float = INF
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance:
					shortest_distance = distance
					closest_enemy = enemy
					
	return closest_enemy


func shoot(enemy: Node) -> void:
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.init(enemy, damage)
