extends UnlockNode

#Unlock condition: Player Flower unlocks when you deal 1000 of each damange type in a single run.
const DAMAGE_THRESHOLD = 1000;

var damageDealt : Array[float];

func subscribe_to_signals():
	damageDealt.resize(GlobalEnums.DAMAGE_TYPES.COUNT)
	damageDealt.fill(0.0)
	UnlockSignals.elemental_damage_dealt.connect(IncrementElemDamage)

func IncrementElemDamage(type : GlobalEnums.DAMAGE_TYPES, amount : int):
	if isLocked:
		damageDealt[type] = amount;
		var dealtAboveThreshold = true;
		for damage in damageDealt:
			if damage < DAMAGE_THRESHOLD:
				dealtAboveThreshold = false;
		dealtAboveThreshold = true; #TODO Remove this immediately after your tests!
		if(dealtAboveThreshold):
			UnlockThisNode();
			UnlockSignals.elemental_damage_dealt.disconnect(IncrementElemDamage)
