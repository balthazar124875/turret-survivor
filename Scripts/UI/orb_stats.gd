extends Control

@onready var labelInnerOrbs = $InnerOrbLabel
@onready var labelOuterOrbs = $OuterOrbLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.orb_amount_increased.connect(update_orb_stat_labels)
	update_orb_stat_labels(OrbHandler.playerOrbs.size(), OrbHandler.maxNrInnerOrbs, OrbHandler.playerOrbsOuter.size(), OrbHandler.maxNrOuterOrbs)

func update_orb_stat_labels(nrInner : int, maxInner : int, nrOuter : int, maxOuter : int) -> void:
	labelInnerOrbs.text = "#Inner orbs: " + str(nrInner) + "/" + str(maxInner);
	labelOuterOrbs.text = "#Outer orbs: " + str(nrOuter) + "/" + str(maxOuter);
	#health_label.text = str("HP: ", str(int(newValue)), "/", str(int(maxHealth)))
	#health_bar.value = newValue
	#health_bar.max_value = maxHealth
	pass
