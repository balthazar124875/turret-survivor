extends PassiveUpgrade

class_name AugmentUpgrade

func applyUpgradeToPlayer(player: Player) -> void:
	player.playerUpgrades.push_back(self)
	reparentToPlayer(player)

func reparentToPlayer(player: Player) -> void:
	player.get_node("./Upgrades/Augments").add_child(self)

func get_tooltip() -> String:
	return "[b]" + upgradeName + "[/b] \n" + get_description()

func get_description() -> String:
	return description
