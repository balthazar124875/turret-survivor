extends Upgrade

class_name CircleUpgrade

var iconPrefab : Node2D #TODO: CircleUpgradeIcon

func _ready() -> void:
	type = UpgradeType.CIRCLE
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	pass

func applyUpgradeToCircle(circle : Circle) -> void:
	pass
	
func reparentToCircle(circle: Circle) -> void:
	circle.get_node("Upgrades").add_child(self)
