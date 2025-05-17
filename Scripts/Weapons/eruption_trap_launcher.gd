extends TrapLauncher

class_name EruptionTrapLauncher

@export var base_eruption_radius = 150
@export var base_area = 1

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 damage * player.damageMultiplier * gun_damage_multiplier, base_area * player.areaSizeMultiplier, trap_duration)
	obj.eruption_radius = base_eruption_radius * player.areaSizeMultiplier
	
func apply_level_up():
	if(level == 5):
		damage += 1.5
		return
	if(level == 10):
		damage += 2.5
		return
	
	match level % 2:
		1:
			damage += 1
		0:
			cooldown *= 0.95

func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Ignites enemies"
