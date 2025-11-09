extends AugmentUpgrade

func _ready():
	SignalBus.convert_hit_type.connect(overrideDamageType)
	pass
	
func overrideDamageType(hit: Hit) -> void:
	var rng = RandomNumberGenerator.new()
	var rndType = rng.randi_range(0, GlobalEnums.ELEMENTAL_DAMAGE_TYPES.size()-1);
	hit.type = GlobalEnums.ELEMENTAL_DAMAGE_TYPES[rndType];
	pass
