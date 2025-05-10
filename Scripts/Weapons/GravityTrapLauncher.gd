extends TrapLauncher

class_name GravityTrapLauncher

var magnetic_traps = false
@export var base_area = 1
@export var base_pull_distance = 150

func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 damage * player.damageMultiplier * gun_damage_multiplier, base_area * player.areaSizeMultiplier, trap_duration)
	obj.pull_radius = base_pull_distance
	
func apply_level_up():
	if(level == 5):
		damage += 1
		return
	if(level == 10):
		magnetic_traps = true
		return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			damage += 1
		4:
			base_pull_distance += 50
