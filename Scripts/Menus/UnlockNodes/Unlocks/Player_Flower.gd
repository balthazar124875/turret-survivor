extends UnlockNode

#Unlock condition: Player Flower unlocks when you deal 1000 of each damange type in a single run.
const DAMAGE_THRESHOLD = 1000;

var damageDealt : Array[float];

func _ready():
	unlockCondition = "Deal " + str(DAMAGE_THRESHOLD) + " damage of each element (fire, ice, lighting, poison, magic) in a single run."
	pass

func subscribe_to_signals():
	damageDealt.resize(GlobalEnums.DAMAGE_TYPES.COUNT)
	damageDealt.fill(0.0)
	UnlockSignals.elemental_damage_dealt.connect(IncrementElemDamage)

func IncrementElemDamage(type : GlobalEnums.DAMAGE_TYPES, amount : int):
	if isLocked:
		damageDealt[type] = amount;
		var dealtAboveThreshold = true;
		for elementalType in GlobalEnums.ELEMENTAL_DAMAGE_TYPES:
			if damageDealt[elementalType] < DAMAGE_THRESHOLD:
				dealtAboveThreshold = false;
		if(dealtAboveThreshold):
			UnlockThisNode();
			UnlockSignals.elemental_damage_dealt.disconnect(IncrementElemDamage)
