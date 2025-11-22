extends BaseGun

@export var chains = 3
@export var chain_range = 400

var chain_damage_bonus = 0

func shoot_enemies(targets: Array[Node]) -> void:
	for enemy in targets:
		var glaive = bullet.instantiate()
		glaive.init_with_target(enemy, get_total_damage(), base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time, source)
		glaive.chains = chains + player.extraChains
		glaive.chain_range = chain_range * player.rangeMultiplier
		glaive.extra_damage_on_chain = chain_damage_bonus
		
		add_child(glaive)
		if(GlobalEnums.WEAPON_VARIATION_TYPE_SWAPS.has(variation)):
			glaive.set_damage_type_and_color(damage_type, variation_color)
	
func _delete_after_time(timeout, bullet):
	await get_tree().create_timer(timeout).timeout
	bullet.queue_free()
	
func apply_level_up():
	
	damage += 0.5
	if(level == 5):
		chains += 2
		return
	if(level == 10):
		chain_damage_bonus = 0.1
		return
	
	match level % 4:
		1:
			chain_range += 25
		2:
			cooldown *= 0.9
		3:
			range += 50
		0:
			chains += 1

func get_custom_tooltip_text() -> String: #override this
	return "\nChains: " + str(chains)
	
func get_lvl10_bonus_description() -> String:
	return "\nLvl [color=yellow]10[/color]: Glaives increase in damage each chain"
