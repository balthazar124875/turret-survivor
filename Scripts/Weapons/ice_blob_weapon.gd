extends BaseGun

class_name IceBlobWeapon
	
func shoot(enemy: Node) -> void:
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.init_with_direction(direction, damage * player.damageMultiplier * gun_damage_multiplier, 
	base_projectile_speed, bullet_life_time, source)
	bullet.pierce = pierce;
	
func apply_level_up():
	if(level == 5):
		return
	if(level == 10):
		
		return
	
	match level % 5:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
