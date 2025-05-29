extends AugmentUpgrade

@export var cooldown: float = 300

var on_cd: bool = false

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	if(player.health < player.maxHealth * 0.05 && !on_cd):
		player.modify_health(player.maxHealth * 0.5)
		player.modify_stat(GlobalEnums.PLAYER_STATS.ATTACK_SPEED, 10)
		player.modify_stat(GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER, 10)
		
		var enemies = get_node("/root/EmilScene/Enemies")
		for e in enemies.get_children():
			e.current_action_speed = 0
			
		await get_tree().create_timer(5).timeout
		for e in enemies.get_children():
			e.current_action_speed = 1
			
		player.modify_stat(GlobalEnums.PLAYER_STATS.ATTACK_SPEED, -10)
		player.modify_stat(GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER, -10)
		
		on_cd = true
		reset_cd()

func reset_cd() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cd = false

func get_description() -> String:
	var text = "Gives temporary immense power when approaching death"
	text += "\n[color=yellow]" + str(cooldown) + "[/color] seconds cooldown."
	if(on_cd):
		text += "\nON CD!!"
	return text

	
