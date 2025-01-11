extends Upgrade

@export var stat_type: GlobalEnums.PLAYER_STATS
@export var amount: float

func _ready() -> void:
	type = UpgradeType.PLAYER_STAT_UP
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	player.modify_stat(stat_type, amount)
	
