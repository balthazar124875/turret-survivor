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
	
func get_fireRate() -> String:
	return "\nFire rate: [color=yellow]" + String.num(1 * localAttackSpeedBonus * player.attackSpeedMultiplier / cooldown, 2) + "[/color] shots/sec"
	
func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Repeatedly shooting increases fire rate by [color=yellow]" + str(100 * intensifyShotBonusSpeed) + "%[/color] each shot"
