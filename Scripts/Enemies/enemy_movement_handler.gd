class_name EnemyMovementHandler

var enemy: Enemy

var displacement_path: Path2D
var displacement_path_follow: PathFollow2D
var displacement_speed: float
var current_zigzag_cooldown = 0
var attack_range: float = 100
var zigzag_tween: Tween

func _init(enemy: Enemy):
	self.enemy = enemy

func handle_movement(delta: float) -> void:
	if(enemy.state == Enemy.EnemyState.DISPLACEMENT):
		move_along_path(delta)
	else:
		var current_position = enemy.global_position
		
		# Handle attacks
		if enemy.t > enemy.attack_cooldown:
			if enemy.objectObstructingEnemy != null:
				enemy.t = 0
				enemy.objectObstructingEnemy.take_damage(enemy.damage, enemy)
				return
			elif current_position.distance_to(enemy.target_position) < attack_range:
				enemy.attack_handler.attack()
				return

		# If blocked, or close to player don't move
		if enemy.objectObstructingEnemy != null || current_position.distance_to(enemy.target_position) < 100:
			if zigzag_tween != null:
				zigzag_tween.kill()
			return 
			
		match enemy.movement_type:
			Enemy.EnemyMovementType.ZIGZAG:
				current_zigzag_cooldown += delta
				if current_zigzag_cooldown > enemy.zigzag_cooldown_time:
					if current_position.distance_to(enemy.target_position) > 200:
						apply_zigzag_tween(enemy.zigzag_angle)
						current_zigzag_cooldown = 0
					elif current_position.distance_to(enemy.target_position) > attack_range:
						apply_zigzag_tween(0)
						current_zigzag_cooldown = 0
				else:
					if enemy.linear_velocity.length() > 0.1: # Avoid decelerating tiny velocities indefinitely
						enemy.linear_velocity = enemy.linear_velocity.lerp(Vector2.ZERO,  delta * 5)
			Enemy.EnemyMovementType.NORMAL:
				var direction = (enemy.target_position - current_position).normalized()
				if current_position.distance_to(enemy.target_position) > attack_range:  # Adjust tolerance as needed
					enemy.global_position += direction * enemy.speed * delta * enemy.current_action_speed
					if enemy.rotational_speed != 0:
						# decides direction of rotational movement
						var direction_sign = 1
						if enemy.random_shake_movement_enabled: 
							direction_sign = randi_range(-1,1)
						enemy.global_position += direction_sign * direction.rotated(deg_to_rad(90)) * enemy.rotational_speed * delta * enemy.current_action_speed

func apply_zigzag_tween(degree_offset: float):
	var current_position = enemy.global_position
	var direction = (enemy.target_position - current_position).normalized()
	var angle_deg = -degree_offset if randf() < 0.5 else degree_offset
	var rotated_direction = direction.rotated(deg_to_rad(angle_deg))
	zigzag_tween = enemy.get_tree().create_tween()
	if (enemy.target_position - (current_position + rotated_direction * enemy.speed)).length() > attack_range: 
		zigzag_tween.tween_property(enemy, "global_position", current_position + rotated_direction * enemy.speed, enemy.zigzag_tween_time).set_trans(Tween.TRANS_CUBIC)
	else:
		zigzag_tween.tween_property(enemy, "global_position", current_position + direction * enemy.speed, enemy.zigzag_tween_time).set_trans(Tween.TRANS_CUBIC)

func add_displacement(displacement_vector: Vector2, speed: float) -> void:
	if(enemy.cc_effectiveness == 0 || enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED)):
		return
	
	enemy.state = Enemy.EnemyState.DISPLACEMENT
	SignalBus.enemy_displaced.emit(self)
	displacement_speed = speed
	create_curve(enemy.global_position + (displacement_vector)) #reduce with cc_effectiveness?
	
func create_curve(target_pos: Vector2, arc_height = 25):
	displacement_path = Path2D.new()
	displacement_path_follow = PathFollow2D.new()
	
	var curve = Curve2D.new()
	curve.add_point(enemy.position)
	curve.add_point((enemy.position + target_pos) / 2 - Vector2(0, arc_height))  # Arc control point
	curve.add_point(target_pos)
	
	var current_pos = enemy.global_position
	
	displacement_path_follow.loop = false
	displacement_path.curve = curve
	enemy.add_child(displacement_path)
	displacement_path.add_child(displacement_path_follow)

func move_along_path(delta: float):
	if displacement_path_follow.progress_ratio >= 1:
		enemy.state = Enemy.EnemyState.MOVE
		
	displacement_path_follow.progress += displacement_speed * delta
	enemy.position = displacement_path_follow.position
