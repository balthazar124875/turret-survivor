extends BaseGun

class_name VineTrapLauncher

var poison = false
var base_area = 1
var extra_vines = 0
var root_duration = 1

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 damage * player.damageMultiplier, base_area * player.areaSizeMultiplier)
	obj.vine_amount += extra_vines
	obj.root_duration = root_duration
	
func apply_level_up():
	if(level == 5):
		extra_vines += 1
		damage += 0.5
		return
	if(level == 10):
		poison = true
		return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			base_area += 0.1
		4:
			root_duration += 0.25 #öka root duration is
