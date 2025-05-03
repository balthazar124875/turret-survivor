extends BaseGun

class_name ChargeLaser

@export var base_laser_width = 2.5

func shoot(enemy: Node) -> void:
		var current_position = global_position
		var bullet = bullet.instantiate()
		var direction = (enemy.global_position - current_position).normalized()
		bullet.look_at(direction)
		bullet.position = bullet.position + direction * 30
		bullet.damage_per_tick = get_modified_damage()
		bullet.source = "Charge laser"
		bullet.damage_type = damage_type
		bullet.range = range * player.rangeMultiplier
		bullet.laser_width = base_laser_width * player.areaSizeMultiplier
		add_child(bullet)

func apply_level_up():
	if(level == 5):
		damage += 2
		return
	if(level == 10):
		base_laser_width += 2
		return
	
	match level % 5:
		1:
			range += 20
		2:
			cooldown *= 0.95
		3:
			base_laser_width += 0.5
		4:
			damage += 1
