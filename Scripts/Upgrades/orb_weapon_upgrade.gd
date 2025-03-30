extends WeaponUpgrade

class_name OrbWeaponUpgrade

#Orbs won't level up, we only add it to player arsenal
func applyUpgradeToPlayer(player: Player) -> void:
	var new_weapon = weapon_scene.instantiate()
	player.get_node("./Weapons").add_child(new_weapon)
	weapon = new_weapon

func reparentToPlayer(player: Player) -> void:
	player.get_node("Upgrades/Weapons").add_child(self)
