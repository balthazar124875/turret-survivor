extends SimpleGun

@export var poison_damage_per_tick: float = 1
@export var poison_duration: float = 2.0

func add_bullet_extra_effects(bullet: Bullet):
	super.add_bullet_extra_effects(bullet)
	bullet.poison_damage_per_tick = poison_damage_per_tick
	bullet.poison_duration = poison_duration
	
# TODO: Add other poison level ups
func apply_level_up():
	if(level == 5):
		cooldown *= 0.8
		return
	if(level == 10):
		local_projectile_speed_multiplier *= 0.75
		bullet_life_time *= 1.33
		return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			poison_duration += 1
		4:
			poison_damage_per_tick += 1
