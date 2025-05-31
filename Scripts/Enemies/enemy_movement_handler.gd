class_name EnemyMovementHandler

var enemy: Enemy

var displacement_path: Path2D
var displacement_path_follow: PathFollow2D
var displacement_speed: float

func _init(enemy: Enemy):
	self.enemy = enemy

func handle_movement(delta: float) -> void:
	if(enemy.state == Enemy.EnemyState.DISPLACEMENT):
		move_along_path(delta)
	else:
		var current_position = enemy.global_position
		var direction = (enemy.target_position - current_position).normalized()
		# Move towards the target position
		if !enemy.objectObstructingEnemy:
			if current_position.distance_to(enemy.target_position) > 100:  # Adjust tolerance as needed
				enemy.global_position += direction * enemy.speed * delta * enemy.current_action_speed
				if enemy.rotational_speed != 0:
					# decides direction of rotational movement
					var direction_sign = 1
					if enemy.random_shake_movement_enabled: 
						direction_sign = randi_range(-1,1)
					enemy.global_position += direction_sign * direction.rotated(deg_to_rad(90)) * enemy.rotational_speed * delta * enemy.current_action_speed
			elif enemy.t > enemy.attack_cooldown: 
				enemy.attack_handler.attack()
		elif enemy.t > enemy.attack_cooldown:
			enemy.t = 0
			enemy.objectObstructingEnemy.take_damage(enemy.damage, enemy)

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
