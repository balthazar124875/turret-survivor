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
	
	#level up gun

func reparentToPlayer(player: Player) -> void:
	self.reparent(player.get_node("./Upgrades/Weapons"))
