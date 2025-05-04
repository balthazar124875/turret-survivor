extends AugmentUpgrade

var stats_buffs: Dictionary = {
	GlobalEnums.PLAYER_STATS.ATTACK_SPEED: 3,
	GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER: 2.5,
	GlobalEnums.PLAYER_STATS.PROJECTILE_SPEED_MULTIPLIER: 3,
	GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER: 1.5,
	GlobalEnums.PLAYER_STATS.EXTRA_PROJECTILES: 5,
	GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME: 40,
	GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION: 150,
	GlobalEnums.PLAYER_STATS.BONUS_LUCK: 10,
	GlobalEnums.PLAYER_STATS.BONUS_PIERCE: 5, 
	GlobalEnums.PLAYER_STATS.BONUS_BOUNCE: 0.7
}

var current_buff: GlobalEnums.PLAYER_STATS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(new_wave)
	buff_random_stat()
	pass # Replace with function body.

func new_wave(wave: int):
	if(current_buff != null):
		player.modify_stat(current_buff, -stats_buffs[current_buff], upgradeName)
	buff_random_stat()
	
func buff_random_stat():
	var stat = get_random_stat()
	player.modify_stat(stat, stats_buffs[stat], upgradeName)
	current_buff = stat
	
func get_random_stat() -> GlobalEnums.PLAYER_STATS:
	var keys = stats_buffs.keys()
	return keys[randi() % keys.size()]
	
	
func get_current_bonus() -> String:
	var text = ""
	var percentage = false
	match current_buff:
		GlobalEnums.PLAYER_STATS.ATTACK_SPEED: 
			text = "% attack speed"
			percentage = true
		GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER:
			text = "% bonus damage"
			percentage = true
		GlobalEnums.PLAYER_STATS.PROJECTILE_SPEED_MULTIPLIER:
			text = "% projectile speed"
			percentage = true
		GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER:
			text = "% extra area size"
			percentage = true
		GlobalEnums.PLAYER_STATS.EXTRA_PROJECTILES:
			text = " extra projetiles"
		GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME:
			text = " bonus income"
		GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION:
			text = " bonus health regeneration"
		GlobalEnums.PLAYER_STATS.BONUS_LUCK:
			text = " bonus luck"
		GlobalEnums.PLAYER_STATS.BONUS_PIERCE:
			text = " bonus pierce"
		GlobalEnums.PLAYER_STATS.BONUS_BOUNCE:
			text = "% bonus bounce chance"
			percentage = true
	return "[color=yellow]" + str(stats_buffs[current_buff] * (100 if percentage else 1)) + "[/color]" + text

func get_description() -> String:
	return "Recieve a new buff each round. \nCurrent buff: +" + get_current_bonus()
