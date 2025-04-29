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

@onready var player = get_node("/root/EmilScene/Player")
var currentBuff: GlobalEnums.PLAYER_STATS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(new_wave)
	buff_random_stat()
	pass # Replace with function body.

func new_wave(wave: int):
	if(currentBuff != null):
		player.modify_stat(currentBuff, -stats_buffs[currentBuff], upgradeName)
	buff_random_stat()
	
func buff_random_stat():
	var stat = get_random_stat()
	player.modify_stat(stat, stats_buffs[stat], upgradeName)
	currentBuff = stat
	
func get_random_stat() -> GlobalEnums.PLAYER_STATS:
	var keys = stats_buffs.keys()
	return keys[randi() % keys.size()]
