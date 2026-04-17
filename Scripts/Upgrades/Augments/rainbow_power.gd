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

func get_description() -> String:
	var text = "Dealing damage with an element gives it a damage bonus for the future."
	 #damage for that element goes up by 1. (Damage requirements increases by 50% each time an element power increases by"
	#for type in GlobalEnums.DAMAGE_TYPES.keys():
		#text += "\n[b]: [/b][color=green]" + str(damageDealt[type]) + " ( " + str(damageDealt[type] -= damageThresholdForLevelUp[type])
	
	text +=  "\nGranting:"
	var type = GlobalEnums.DAMAGE_TYPES.FIRE
	text += "\n[color=orange][b]Fire: [/b]+" + String.num(player.GetBaseDamage(type), 0) + " (" + String.num(damageThresholdForLevelUp[type] - damageDealt[type], 0) + " left)"
	
	type = GlobalEnums.DAMAGE_TYPES.ICE
	text += "\n[color=cyan][b]Ice: [/b]+" + String.num(player.GetBaseDamage(type), 0) + " (" + String.num(damageThresholdForLevelUp[type] - damageDealt[type], 0) + " left)"
	
	type = GlobalEnums.DAMAGE_TYPES.LIGHTNING
	text += "\n[color=yellow][b]Lightning: [/b]+" + String.num(player.GetBaseDamage(type), 0) + " (" + String.num(damageThresholdForLevelUp[type] - damageDealt[type], 0) + " left)"
	
	type = GlobalEnums.DAMAGE_TYPES.MAGIC
	text += "\n[color=purple][b]Magic: [/b]+" + String.num(player.GetBaseDamage(type), 0) + " (" + String.num(damageThresholdForLevelUp[type] - damageDealt[type], 0) + " left)"
	
	type = GlobalEnums.DAMAGE_TYPES.POISON
	text += "\n[color=green][b]Poison: [/b]+" + String.num(player.GetBaseDamage(type), 0) + " (" + String.num(damageThresholdForLevelUp[type] - damageDealt[type], 0) + " left)"
	
	return text
