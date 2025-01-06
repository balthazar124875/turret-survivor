extends BaseGun

@export var chains = 4
@export var chain_range = 100

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

func shoot(target_enemy: Node) -> void:
	var chains = chains
	
	
	var targets = []
	targets.append(target_enemy)
	
	for enemy in enemy_parent.get_children():
		if enemy.is_inside_tree() && enemy.is_alive() && enemy != target_enemy:
			var distance = target_enemy.global_position.distance_to(enemy.global_position)
			if(distance < chain_range):
				targets.append(enemy)
				if(targets.size() >= chains):
					break
					
					
	var bullet = bullet.instantiate()
	add_child(bullet)
	var thunder = bullet.find_child("Thunder")
	thunder.clear_points()
	thunder.add_point(Vector2(0, 0))
	var i = 0
	for enemy in targets:
		thunder.add_point((enemy.global_position - self.global_position))
		enemy.take_damage(damage)
		i += 1
		
	call_deferred("_delete_after_time", bullet_life_time, bullet)
	
	
func _delete_after_time(timeout, bullet):
	await get_tree().create_timer(timeout).timeout
	bullet.queue_free()
