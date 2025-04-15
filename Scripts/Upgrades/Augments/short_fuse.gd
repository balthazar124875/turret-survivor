extends AugmentUpgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.trap_landed.connect(on_trap_landed)
	pass # Replace with function body.

func on_trap_landed(trap: Trap):
	trap.trigger_trap()
