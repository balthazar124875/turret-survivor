extends AugmentUpgrade

var possible_tags = [
	Upgrade.TAGS.FIRE,
	Upgrade.TAGS.PHYSICAL,
	Upgrade.TAGS.COLD,
	Upgrade.TAGS.LIGHTNING,
	Upgrade.TAGS.POISON,
	Upgrade.TAGS.MAGIC
]

var damage_type: GlobalEnums.DAMAGE_TYPES
var boosted_tag: Upgrade.TAGS

@export var charge_amount = 0.25


var upgrade_tags: Array[Upgrade.TAGS] = []

func _ready() -> void:
	SignalBus.damage_done.connect(check_charge)
	SignalBus.current_wave_updated.connect(wave_updated)
	upgrade_tags.append(Upgrade.TAGS.WEAPON)
	wave_updated(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wave_updated(value: float):
	if(upgrade_tags.size() > 1):
		upgrade_tags.remove_at(1)
	boosted_tag = possible_tags[randi() % possible_tags.size()]
	upgrade_tags.append(boosted_tag)
	var type_values = GlobalEnums.DAMAGE_TYPES.values()
	damage_type = type_values[randi() % type_values.size()]

func check_charge(enemy: Enemy, amount: float, damage_type: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(direct && damage_type == self.damage_type):
		var upgrade = player.get_random_upgrade_with_tags(upgrade_tags)
		if(upgrade != null):
			upgrade.weapon.charge += upgrade.weapon.charge * charge_amount

func get_description() -> String:
	return "Dealing " + TooltipHelper.get_damage_type_text(damage_type) + " damage charges a " + get_enum_name(boosted_tag) + " weapon [color=yellow]" + str(charge_amount * 100) + "%"
	
func get_enum_name(tag):
	for name in Upgrade.TAGS.keys():
		if Upgrade.TAGS[name] == tag:
			return name
	return "UNKNOWN"
