extends BaseGun

class_name DiscLauncher

var armor_shred: bool = false

func shoot(enemy: Node) -> void:	
	var bulletAmount: int = base_projectile_amount + player.extraProjectiles
	var random_offset = randf_range(0, 2 * PI) 
	for i in bulletAmount:
		var bullet = bullet.instantiate()
		var speed = base_projectile_speed * player.projectileSpeedMultipler
		var offset = Vector2(cos(random_offset + i * (2 * PI / bulletAmount)), sin(random_offset + i * (2 * PI / bulletAmount)))
		bullet.init_with_direction(offset, damage * player.damageMultiplier * gun_damage_multiplier, base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time, "Disc Launcher")
		bullet.rotation_speed = speed
		bullet.outward_speed = speed / 2
		
		if(armor_shred):
			bullet.armor_reduction = 1
			
			
			
		bullet.pierce = pierce + player.extraPierce
		bullet.life_time = bullet_life_time
		bullet.scale = Vector2(1, 1) * player.areaSizeMultiplier
		bullet.set_damage_type_and_color(damage_type, variation_color)
		add_child(bullet)

func apply_level_up():
	if(level == 5):
		base_projectile_amount += 1
		return
	if(level == 10):
		armor_shred = true
		base_projectile_amount += 1
		return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			pierce += 2
		4:
			damage += 1

func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Disks reduce enemy armor by [color=red]1[/color]"
