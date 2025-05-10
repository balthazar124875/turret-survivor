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
	 damage * player.damageMultiplier * gun_damage_multiplier, base_area * player.areaSizeMultiplier, trap_duration)
	obj.knockback_radius = base_knockback_radius
	obj.knockback_distance = base_knockback_distance
	obj.delayed_detonation = delayed_detonation
	
func apply_level_up():
	if(level == 5):
		damage += 1
		return
	if(level == 10):
		delayed_detonation = true
		return
	
	match level % 5:
		1:
			base_knockback_radius += 50
		2:
			cooldown *= 0.95
		3:
			damage += 1
		4:
			base_knockback_distance += 50
