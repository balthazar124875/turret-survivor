extends PassiveUpgrade

@export var damage_limit = 0.3 #10%
var sum = 0

@export var interval = 3.0 #10%
@export var cooldown = 3.0 #10%
var active = true

@export var knockback_radius = 100
@export var knockback_distance = 125
@export var knockback_speed = 400

@export var shockwave_vfx: PackedScene

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	if(!active):
		return
		
	sum += value
	if(sum > player.maxHealth * damage_limit):
		trigger()
	reduce_sum(value)
	
func reduce_sum(value: float) -> void:
	await get_tree().create_timer(interval).timeout
	sum -= value
	if(sum < 0):
		sum = 0

func trigger():
	var vfx = shockwave_vfx.instantiate()
	vfx.global_position = player.global_position
	get_node("/root/EmilScene/ParticleNode").add_child(vfx)
	
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	for enemy in enemy_parent.get_children():
		if enemy.is_inside_tree() && enemy.is_alive():
			var distance = player.global_position.distance_to(enemy.global_position)
			if (distance < knockback_radius):
				var vector_dir = (enemy.global_position - player.global_position).normalized() * knockback_distance
				
				enemy.add_displacement(vector_dir, knockback_speed)
	sum = 0
	active = false
	await get_tree().create_timer(cooldown).timeout
	active = true

func apply_level_up():
	match upgradeAmount % 3:
		0:
			interval += 0.1
			cooldown -= 0.1
		1:
			damage_limit -= 0.01
		2:
			knockback_distance += 10

func get_description() -> String:
	var text = "After taking [color=red]" + str(damage_limit * 100) + "%[/color] of maximum health as damage within [color=yellow]" + str(interval) + "[/color] seconds knockback all nearby enemies"
	text += "\n[color=yellow]" + str(cooldown) + "[/color] seconds cooldown"
	#if(ability):
		#text += "\nLvl [color=yellow]10[/color]: Launches a freezing gust in a cone when hit [color=red](Not implemented)"
	return text
