extends BaseGun

class_name BasicSword

@export var base_swing_degrees:float = 90
@export var base_sword_scale:float = 1

func shoot(enemy: Node) -> void:
		var current_position = player.global_position
		var bullet = bullet.instantiate()
		var direction = (enemy.global_position - current_position).normalized()
		bullet.look_at(direction)
		bullet.position = Vector2(0,0)
		bullet.source = source
		bullet.damage = damage * gun_damage_multiplier
		bullet.swing_degrees = base_swing_degrees * player.areaSizeMultiplier
		bullet.sword_scale = base_sword_scale * player.rangeMultiplier
		add_child(bullet)

func apply_level_up():
	if(level == 5):
		base_swing_degrees += 10
		return
	if(level == 10):
		base_sword_scale += 0.4
		return
	
	match level % 5:
		1:
			base_swing_degrees += 5
		2:
			cooldown *= 0.95
		3:
			base_sword_scale += 0.1
		4:
			damage += 1
