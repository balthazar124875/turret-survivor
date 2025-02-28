extends Upgrade

class_name WeaponUpgrade

@export var weapon_scene : PackedScene;

func _ready() -> void:
	type = UpgradeType.WEAPON
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	var new_weapon = weapon_scene.instantiate()
	player.get_node("./Weapons").add_child(new_weapon)

func reparentToPlayer(player: Player) -> void:
	self.reparent(player.get_node("./Upgrades/Weapons"))
