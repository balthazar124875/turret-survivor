extends Node2D


var active_child: int = 0
@onready var number_of_backgrounds: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(update_background)
	number_of_backgrounds = get_child_count()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_background(wave: int):
	if(wave % 10 == 0):
		var c1 = get_child(active_child)
		var c2 = get_child((active_child + 1) % number_of_backgrounds)
		c1.start_disolve(1, -1)
		c2.reset()
		active_child = (active_child + 1) % number_of_backgrounds
