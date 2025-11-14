extends TrapLauncher

class_name VineTrapLauncher

var poison = false
var base_area = 1
var extra_vines = 0
var root_duration = 1

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 get_total_damage(), base_area * player.areaSizeMultiplier, trap_duration)
	obj.vine_amount += extra_vines
	obj.root_duration = root_duration
	obj.poison = poison
	
func apply_level_up():
	if(level == 5):
		extra_vines += 1
		damage += 0.5
		return
	if(level == 10):
		extra_vines += 1
		poison = true
		return
	
	match level % 5:
		1:
			damage += 1
		2:
			cooldown *= 0.95
		3:
			damage += 1
		4:
			root_duration += 0.25 #öka root duration is

func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Vines poison enemies for [color=green]" + str(damage * gun_damage_multiplier * (root_duration / 0.5)) + "[/color] over [color=yellow]" + str(root_duration) + "[/color] seconds"
