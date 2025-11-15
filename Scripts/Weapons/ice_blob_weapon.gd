extends BaseGun

class_name IceBlobWeapon
	
var grow_faster : bool = false
var base_area : float = 1.0

func shoot(enemy: Node) -> void:
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.init_with_direction(direction, damage * player.damageMultiplier * gun_damage_multiplier, 
	base_projectile_speed, bullet_life_time, source)
	bullet.pierce = pierce;
	bullet.scale *= Vector2(base_area, base_area);
	bullet.grow_speed = 0.375 if grow_faster else 0.75
	
func apply_level_up():
	if(level == 5):
		return
	if(level == 10):
		grow_faster = true
		return
	
	match level % 2:
		0:
			base_area += 0.05
			pass
		1:
			gun_damage_multiplier += 0.1
			pass

func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Blob grows a lot faster when hitting enemies"
