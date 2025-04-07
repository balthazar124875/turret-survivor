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
	
	var lines = []
	
	var chains = chains + player.extraChains
	
	var enemyList = enemy_parent.get_children()
	enemyList.erase(target_enemy)
	
	var targets: Array[Node] = []
	targets.append(target_enemy)
		
	lines.append(targets)
		
	for i in chains:
		var closestDistance = chain_range * player.rangeMultiplier
		var nextTarget
		for enemy in enemyList:
			var enemyDistance = getDistance(targets.back(),enemy)
			if(enemyDistance < closestDistance):
				if enemy.is_inside_tree() && enemy.is_alive():
					nextTarget = enemy
					closestDistance = enemyDistance
		
		if(nextTarget != null):
			targets.append(nextTarget)
			enemyList.erase(nextTarget)	
		else:
			break; 	
		
	if(discharge):
		var chainAmount = chains
		for i in targets:
			var newTargetList: Array[Node] = []
			newTargetList.append(i)
			chainAmount -= 1
			for j in chainAmount:
				var closestDistance = chain_range * player.rangeMultiplier
				var nextTarget
				for enemy in enemyList:
					var enemyDistance = getDistance(i, enemy)
					if(enemyDistance < closestDistance):
						if enemy.is_inside_tree() && enemy.is_alive():
							nextTarget = enemy
							closestDistance = enemyDistance
				
				if(nextTarget != null):
					newTargetList.append(nextTarget)
					enemyList.erase(nextTarget)	
				else:
					break;
			
			if newTargetList.size() > 1: 	
				lines.append(newTargetList)
				
	for i in lines:	
		var bullet = bullet.instantiate()
		add_child(bullet)
		bullet.set_targets(i)
		for enemy in i:
			enemy.take_damage(damage * player.damageMultiplier, "Chain Lightning")
			if(discharge):
				#do knockback on enemy
				pass
			
		call_deferred("_delete_after_time", bullet_life_time, bullet)
	
func getDistance(source: Enemy, enemy: Enemy):
	return source.global_position.distance_to(enemy.global_position)
	
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
			chain_range += 25
		2:
			cooldown *= 0.95
		3:
			range += 50
		4:
			damage += 1
