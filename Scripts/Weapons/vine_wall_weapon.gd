extends BaseGun

class_name VineWall

var vines : Array[VineBullet] = [];

func shoot_area(position: Vector2) -> void:
	var vine = bullet.instantiate()
	add_child(vine)
	vine.global_position = position
	#Put your vine in a list
	var vineHP = 2;
	var vineAttackDmg = 0.5;
	vine.instantiateVineWall(vineHP, vineAttackDmg)

func get_target_area() -> Vector2: #defaults to getting closest
	var screenSize = get_viewport().get_visible_rect().size;
	var distance = 200.0;
	var angle = randf_range(0, PI * 2)
	
	var position = Vector2(1 , 1);
	position = position.rotated(angle)
	position *= distance
	
	position += player.global_position
	return position

func apply_level_up():
	if(level == 5):
			base_projectile_speed += 100
			return
	if(level == 10):
			cooldown *= 0.7
			return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			range += 25
		4:
			damage += 1
