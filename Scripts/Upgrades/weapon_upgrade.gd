extends Upgrade

class_name WeaponUpgrade

@export var weapon_scene : PackedScene;
var weapon: BaseGun

func _ready() -> void:
	type = UpgradeType.WEAPON
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if (upgradeAmount == 1):
		var new_weapon = weapon_scene.instantiate()
		player.get_node("./Weapons").add_child(new_weapon)
		weapon = new_weapon
	else:
		weapon.level_up()

func reparentToPlayer(player: Player) -> void:
	player.get_node("Upgrades/Weapons").add_child(self)

func get_description() -> String:
	var str = description
	str += weapon.get_damage()
	str += weapon.get_fireRate()
	str += weapon.get_damage_type()
	str += weapon.get_custom_tooltip_text()
	if(upgradeAmount >= 10):
		str += weapon.get_lvl10_bonus_description()
	return str
	
