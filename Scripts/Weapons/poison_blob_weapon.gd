extends BaseGun

class_name PoisonBloblWeapon

@export var area_of_effect: float = 1.0

var recursive: bool = false
		
func shoot(enemy: Node) -> void:	
	var target = get_random_target()
	if target == null:
		return
		
	if player.global_position.distance_to(target.global_position) > range * player.rangeMultiplier:
		return
	var bullet = bullet.instantiate()
	if target != null:
		bullet.target_pos = target.global_position - player.global_position
	bullet.speed = base_projectile_speed
	bullet.damage = damage * gun_damage_multiplier
	bullet.start_pos = Vector2(0,0)
	add_child(bullet)
	
func apply_level_up():
	if(level == 5):
			base_projectile_amount += 1
			return
	if(level == 10):
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
