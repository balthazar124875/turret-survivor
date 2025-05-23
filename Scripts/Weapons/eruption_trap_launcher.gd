extends TrapLauncher

class_name EruptionTrapLauncher

@export var base_eruption_radius = 150
@export var base_area = 1

var ignites = false
var ignite_duration = 2
var ignite_damage = 0.25

func shoot_area(position: Vector2) -> void:
	var trap = bullet.instantiate()
	add_child(trap)
	trap.create_trap(Vector2(0, 0), position - global_position, base_projectile_speed * player.projectileSpeedMultipler,
	 damage * player.damageMultiplier * gun_damage_multiplier, base_area * player.areaSizeMultiplier, trap_duration)
	trap.eruption_radius = base_eruption_radius * player.areaSizeMultiplier
	if(ignites):
		trap.ignites = true
		trap.ignite_duration = ignite_duration
		trap.ignite_damage = damage * player.damageMultiplier * gun_damage_multiplier * ignite_damage
	
func apply_level_up():
	if(level == 5):
		damage += 1.5
		return
	if(level == 10):
		damage += 2.5
		ignites = true
		return
	
	match level % 3:
		0:
			cooldown *= 0.95
		1:
			damage += 1
		2:
			base_eruption_radius += 25

func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Ignites enemies for [color=red]" + str(damage * player.damageMultiplier * gun_damage_multiplier * ignite_damage) + "[/color]/0.5sec for [color=yellow]" + str(ignite_duration) + "[/color] seconds"
