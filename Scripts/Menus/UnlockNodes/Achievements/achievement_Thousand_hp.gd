extends UnlockNode

#Unlock condition: Once player reaches 1000 Max hp
const MAX_HP_THRESHOLD = 2000;

func _ready():
	unlockCondition = "Reach" + str(MAX_HP_THRESHOLD) + "Max HP";
	pass

func subscribe_to_signals():
	SignalBus.player_max_health_updated.connect(CheckMaxHP)

func CheckMaxHP(maxHP : int):
	if isLocked:
		if(maxHP >= MAX_HP_THRESHOLD):
			UnlockThisNode();
			SignalBus.player_max_health_updated.disconnect(CheckMaxHP)
