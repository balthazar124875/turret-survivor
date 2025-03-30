extends Control

@onready var labelInnerOrbs = $InnerOrbLabel
@onready var labelOuterOrbs = $InnerOrbLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_health_updated.connect(update_health)

func update_health(newValue: float, maxHealth: float) -> void:
	#health_label.text = str("HP: ", str(int(newValue)), "/", str(int(maxHealth)))
	#health_bar.value = newValue
	#health_bar.max_value = maxHealth
	pass
