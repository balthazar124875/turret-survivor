extends HBoxContainer


# <name, upgrade>
var upgrade_dict: Dictionary = {}
@onready var weapon_container = $ScrollContainer/WeaponContainer
@onready var passive_container = $ScrollContainer2/PassiveContainer
@onready var upgrade_container_scene = preload("res://Scenes/UI/upgrade_container.tscn");

func _ready() -> void:
	SignalBus.upgrade_recieved.connect(add_upgrade)

func add_upgrade(upgrade: Upgrade):

	upgrade_dict[upgrade.upgradeName] = UpgradeListItem.create(upgrade.upgradeAmount, upgrade.icon, upgrade.upgradeName)
	if upgrade.type == Upgrade.UpgradeType.WEAPON:
		add_upgrade_to_container(upgrade, weapon_container)
	elif  upgrade.type == Upgrade.UpgradeType.PASSIVE:
		add_upgrade_to_container(upgrade, passive_container)

func add_upgrade_to_container(upgrade: Upgrade, container):
	var upgrade_container
	if upgrade_dict[upgrade.upgradeName].level == 1:
		upgrade_container = upgrade_container_scene.instantiate()
		container.add_child(upgrade_container)
	else:
		upgrade_container = container.get_node(upgrade.upgradeName)
	upgrade_container.get_node("./LevelContainer/LevelTextLabel").text = "[center]" + str(upgrade_dict[upgrade.upgradeName].level)
	upgrade_container.get_node("./ImageContainer/Sprite2D").texture = upgrade.icon
	upgrade_container.get_node("./NameContainer/NameLabel").text = upgrade.upgradeName
	upgrade_container.name = upgrade.upgradeName

	
