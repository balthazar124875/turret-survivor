extends Node2D


var active_child: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(update_background)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_background(wave: int):
	if(wave % 10 == 0):
		var c1 = get_child(active_child)
		var c2 = get_child((active_child + 1) % 2)
		c1.start_disolve(1, -1)
		c2.reset()
		active_child = (active_child + 1) % 2
