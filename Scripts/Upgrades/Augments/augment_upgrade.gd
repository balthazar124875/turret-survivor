extends PassiveUpgrade

class_name AugmentUpgrade

func applyUpgradeToPlayer(player: Player) -> void:
	player.playerUpgrades.push_back(self)
	reparentToPlayer(player)

func reparentToPlayer(player: Player) -> void:
	player.get_node("./Upgrades/Augments").add_child(self)
