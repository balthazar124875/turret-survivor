extends TrapLauncher

class_name ShockwaveTrapLauncher

var delayed_detonation = false
@export var base_area = 1
@export var base_knockback_radius = 1
@export var base_knockback_distance = 1

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 get_total_damage(), base_area * player.areaSizeMultiplier, trap_duration)
	obj.knockback_radius = base_knockback_radius
	obj.knockback_distance = base_knockback_distance
	obj.delayed_detonation = delayed_detonation
	obj.damage_type = damage_type
	
func apply_level_up():
	if(level == 5):
		damage += 1
		return
	if(level == 10):
		delayed_detonation = true
		return
	
	match level % 5:
		1:
			base_knockback_radius += 30
		2:
			cooldown *= 0.95
		3:
			damage += 1
		4:
			base_knockback_distance += 50
			
func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Trap retriggers again after [color=yellow]10[/color] seconds"
