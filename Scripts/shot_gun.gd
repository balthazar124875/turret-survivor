extends SimpleGun

class_name ShotGun

var intensify : bool = false
@export var intensifyShotBonusSpeed : float = 0.01

func get_target() -> Node:
	var target = super.get_target()
	if(intensify):
		if(target != null):
			localAttackSpeedBonus += intensifyShotBonusSpeed
		else: localAttackSpeedBonus = 1
	
	return target

func apply_level_up():
	if(level == 5):
			base_projectile_amount += 1
			return
	if(level == 10):
			intensify = true
			return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			bullet_spread -= 1
		4:
			damage += 1
