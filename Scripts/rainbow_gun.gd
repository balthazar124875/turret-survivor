extends SimpleGun

class_name RainbowGun

static var element_type = 0;
var superBulletPercentage = 0.1;

func shoot(enemy: Node) -> void:
	var bulletAmount: int = base_projectile_amount + player.extraProjectiles
	var current_position = global_position
	var direction = (enemy.position - current_position).normalized()
	direction = direction.rotated(deg_to_rad(bullet_spread * (bulletAmount / 2)))
	for n in range(bulletAmount):
		var bullet = wrapAroundBullet.instantiate() if wrapAround else bullet.instantiate()
		add_child(bullet)
		bullet.init_with_direction(direction, damage * player.damageMultiplier * gun_damage_multiplier, 
			base_projectile_speed * local_projectile_speed_multiplier * player.projectileSpeedMultipler, bullet_life_time, source)
		bullet.pierce += player.extraPierce
		bullet.bounce += player.extraBounce
		element_type = element_type % (GlobalEnums.ELEMENTAL_DAMAGE_TYPES.size()-1);
		element_type = element_type + 1;
		bullet.set_damage_type_and_color(element_type, GlobalEnums.DamageColor[element_type])
		direction = direction.rotated(-deg_to_rad(bullet_spread))

func apply_level_up():
	if(level == 5):
			base_projectile_amount += 1
			return
	if(level == 10):
			#intensify = true
			return
	
	match level % 5:
		1:
			base_projectile_speed += 50
		2:
			cooldown *= 0.95
		3:
			bullet_spread -= 1
		4:
			damage += 1
	
func get_fireRate() -> String:
	return "\nFire rate: [color=yellow]" + String.num(1 * localAttackSpeedBonus * player.attackSpeedMultiplier / cooldown, 2) + "[/color] shots/sec"
	
func get_lvl10_bonus_description() -> String:
	#"\nLvl [color=yellow]10[/color]: [color=yellow]" + str(100 * multiBulletPercentage) + "%[/color] chance to shoot 3 bullets in rapid succession, with the third bullet guaranteed to apply status effect to enemy."
	return "\nLvl [color=yellow]10[/color]: [color=yellow]" + str(100 * superBulletPercentage) + "%[/color] chance to shoot a giant bullet with maximum pierce that guarantees applied status effect to all enemies it hits."
