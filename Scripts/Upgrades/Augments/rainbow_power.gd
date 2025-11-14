extends AugmentUpgrade

var DAMAGE_THRESHOLD = 1000;
var THRESHOLD_INCREASE_PER_LEVEL = 1.5; #50%
var damageDealt : Array[float];
var damageThresholdForLevelUp : Array[float];

func _ready():
	damageDealt.resize(GlobalEnums.DAMAGE_TYPES.COUNT)
	damageDealt.fill(0.0)
	damageThresholdForLevelUp.resize(GlobalEnums.DAMAGE_TYPES.COUNT)
	damageThresholdForLevelUp.fill(DAMAGE_THRESHOLD)
	SignalBus.elemental_damage_dealt.connect(IncreaseElementalDamage)
	pass
	
func IncreaseElementalDamage(type : GlobalEnums.DAMAGE_TYPES, amount : float) -> void:
	if type == GlobalEnums.DAMAGE_TYPES.PHYSICAL:
		return;
	damageDealt[type] += amount;
	if damageDealt[type] >= damageThresholdForLevelUp[type]:
		damageDealt[type] -= damageThresholdForLevelUp[type];
		player.IncreaseBaseDamage(type, 1.0);
		damageThresholdForLevelUp[type] *= THRESHOLD_INCREASE_PER_LEVEL;
		
	pass
