extends BaseGun

@export var chains = 3
@export var chain_range = 400

var discharge = false

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

func shoot(target_enemy: Node) -> void:
	var chains = chains + player.extraChains
	
	
	var targets: Array[Node] = []
	targets.append(target_enemy)
	
	for enemy in enemy_parent.get_children():
		if enemy.is_inside_tree() && enemy.is_alive() && enemy != target_enemy:
			var distance = target_enemy.global_position.distance_to(enemy.global_position)
			if(distance < chain_range * player.rangeMultiplier):
				targets.append(enemy)
				if(targets.size() >= chains):
					break
					
					
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.set_targets(targets)
	for enemy in targets:
		enemy.take_damage(damage * player.damageMultiplier)
		SignalBus.on_enemy_hit.emit(enemy)
		if(discharge):
			#do knockback on enemy
			pass
		
	call_deferred("_delete_after_time", bullet_life_time, bullet)
	
	
func _delete_after_time(timeout, bullet):
	await get_tree().create_timer(timeout).timeout
	bullet.queue_free()
	
	
func apply_level_up():
	if(level == 5):
		chains += 2
		return
	if(level == 10):
		discharge = true
		return
	
	match level % 5:
		1:
			chain_range += 100
		2:
			cooldown *= 0.95
		3:
			range += 50
		4:
			damage += 1
