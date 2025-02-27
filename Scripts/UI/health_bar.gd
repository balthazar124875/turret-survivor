extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_health_updated.connect(update_health)

func update_health(newValue) -> void:
	value = newValue
