extends AugmentUpgrade

@export var damageBonus = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.trap_landed.connect(on_trap_landed)
	pass # Replace with function body.

func on_trap_landed(trap: Trap):
	trap.base_damage *= (1 + damageBonus)
	trap.trigger_trap()

func get_description() -> String:
	return "Traps detonate instantly upon landing. Increases trap damage by [color=red]" + str(damageBonus * 100) + "%[/color]."
