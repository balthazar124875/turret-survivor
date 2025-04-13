extends BaseGun

class_name ThunderStrike

@export var base_area: float = 1
var double_strike: bool = false
var triple_strike: int = 2

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.global_position = position
	obj.init(bullet_life_time, damage * player.damageMultiplier * gun_damage_multiplier, base_area * player.areaSizeMultiplier)
	if(double_strike):
		#instantly reset cooldown
		if(triple_strike > 0):
			charge = cooldown - 0.15
			triple_strike -= 1
		else:
			triple_strike = 2
	
func apply_level_up():
	if(level == 5):
		double_strike = true
		damage += 1
		return
	
	match level % 5:
		1:
			bullet_life_time += 0.4
		2:
			cooldown *= 0.85
		3:
			base_area += 0.1
		4:
			damage += 1
