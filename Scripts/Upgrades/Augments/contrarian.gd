extends AugmentUpgrade

@onready var upgrade_handler: UpgradeHandler = get_node("/root/EmilScene/GameplayUi/UpgradeHandler")

func _ready() -> void:
	upgrade_handler.weapon_variaty_chance += 1
	
