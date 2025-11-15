extends HBoxContainer


# <name, upgrade>
var upgrade_dict: Dictionary = {}
@onready var weapon_container = $ScrollContainer/WeaponContainer
@onready var passive_container = $ScrollContainer2/PassiveContainer
@onready var upgrade_container_scene = preload("res://Scenes/UI/upgrade_container.tscn");

@onready var tooltipMgr = get_node("/root/EmilScene/GameplayUi/Tooltip")

func _init() -> void:
	SignalBus.upgrade_recieved.connect(add_upgrade)

func add_upgrade(upgrade: Upgrade):

	upgrade_dict[upgrade.upgradeName] = upgrade
	if upgrade.type == Upgrade.UpgradeType.WEAPON:
		add_upgrade_to_container(upgrade, weapon_container)
	elif  upgrade.type == Upgrade.UpgradeType.PASSIVE:
		add_upgrade_to_container(upgrade, passive_container)

func add_upgrade_to_container(upgrade: Upgrade, container):
	var upgrade_container
	if upgrade_dict[upgrade.upgradeName].upgradeAmount == 1:
		upgrade_container = upgrade_container_scene.instantiate()
		container.add_child(upgrade_container)
		upgrade_container.mouse_entered.connect(mouse_enter_augment.bind(upgrade, container))
		upgrade_container.mouse_exited.connect(mouse_exit_augment)
	else:
		upgrade_container = container.get_node(upgrade.upgradeName)
	upgrade_container.get_node("./LevelContainer/LevelTextLabel").text = "[center]" + str(upgrade_dict[upgrade.upgradeName].upgradeAmount)
	upgrade_container.get_node("./ImageContainer/Sprite2D").texture = upgrade.icon
	upgrade_container.get_node("./NameContainer/NameLabel").text = upgrade.upgradeName
	upgrade_container.name = upgrade.upgradeName

func mouse_enter_augment(upgrade: Upgrade, container):
	tooltipMgr.DisplayTooltip(upgrade_dict[upgrade.upgradeName].get_tooltip(), container.get_node(upgrade.upgradeName));
	pass
	
func mouse_exit_augment():
	tooltipMgr.HideTooltip();
