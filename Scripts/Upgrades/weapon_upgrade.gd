extends Upgrade

class_name WeaponUpgrade

@export var weapon_scene : PackedScene;
@export var viable_variations: Array[GlobalEnums.WEAPON_VARIATION] = []

var variation: GlobalEnums.WEAPON_VARIATION
var weapon: BaseGun

func _ready() -> void:
	type = UpgradeType.WEAPON
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if (upgradeAmount == 1):
		var new_weapon = weapon_scene.instantiate()
		player.get_node("./Weapons").add_child(new_weapon)
		weapon = new_weapon
		if(variation != null):
			weapon.set_variation(variation)
			add_variation_tag()
		reparentToPlayer(player)
	else:
		weapon.level_up()

func apply_variation(variation: GlobalEnums.WEAPON_VARIATION):
	self.variation = variation

func reparentToPlayer(player: Player) -> void:
	player.playerUpgrades.push_back(self)
	player.get_node("Upgrades/Weapons").add_child(self)

func get_description() -> String:
	var str = description
	if(variation != GlobalEnums.WEAPON_VARIATION.NONE):
		str += "\n" + IconHandler.get_icon_path(GlobalEnums.WEAPON_VARIATION_NAMES[variation], 32, 32) + ": " + get_variation_description()
	str += weapon.get_damage()
	str += weapon.get_fireRate()
	str += weapon.get_damage_type()
	str += weapon.get_custom_tooltip_text()
	if(upgradeAmount >= 10):
		str += weapon.get_lvl10_bonus_description()
	return str
	
func get_variation_description() -> String:
	match variation:
		GlobalEnums.WEAPON_VARIATION.HEAVY:
			return "Deals double damage, attacks half as fast"
		GlobalEnums.WEAPON_VARIATION.LIGHT:
			return "Deals half damage, attacks twice as fast"
		GlobalEnums.WEAPON_VARIATION.EXTRA_SHOT: #straight upgrade
			return "Shoots an extra projectile"
		GlobalEnums.WEAPON_VARIATION.BLAZING:
			return "Deals fire damage"
		GlobalEnums.WEAPON_VARIATION.SHOCKING:
			return "Deals lightning damage"
		GlobalEnums.WEAPON_VARIATION.SHIVERING:
			return "Deals ice damage"
		GlobalEnums.WEAPON_VARIATION.MYSTIC:
			return "Deals mystic damage"
		GlobalEnums.WEAPON_VARIATION.TOXIC:
			return "Deals poison damage"
	return ""
	
func add_variation_tag() -> void:
	match variation:
		GlobalEnums.WEAPON_VARIATION.BLAZING:
			tags.append(TAGS.FIRE)
		GlobalEnums.WEAPON_VARIATION.SHOCKING:
			tags.append(TAGS.LIGHTNING)
		GlobalEnums.WEAPON_VARIATION.SHIVERING:
			tags.append(TAGS.COLD)
		GlobalEnums.WEAPON_VARIATION.MYSTIC:
			tags.append(TAGS.MAGIC)
		GlobalEnums.WEAPON_VARIATION.TOXIC:
			tags.append(TAGS.POISON)
