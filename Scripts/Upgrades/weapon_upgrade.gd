extends Upgrade

class_name WeaponUpgrade

@export var weapon_scene : PackedScene;

func applyUpgradeToPlayer() -> void:
	var new_weapon = weapon_scene.instantiate()
	var test = get_node("/root/EmilScene/Player/Weapons")
	get_node("/root/EmilScene/Player/Weapons").add_child(new_weapon)
