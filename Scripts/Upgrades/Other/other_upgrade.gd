extends Upgrade

class_name OtherUpgrade

func _ready() -> void:
	type = UpgradeType.OTHER
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(upgradeAmount == 1):
		reparentToPlayer(player)
	apply_level_up()

func reparentToPlayer(player: Player) -> void:
	player.get_node("./Upgrades/Other").add_child(self)
	
func apply_level_up():
	pass
