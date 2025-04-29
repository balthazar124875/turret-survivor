extends RichTextLabel

var display_text: String
var color: String
var initial_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#text = "%.1f" % number
	text = "[color=" + color + "]" + display_text + "[/color]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var modifier = sin(PI * ($LifeTimeTimer.wait_time - $LifeTimeTimer.time_left) / $LifeTimeTimer.wait_time)
	global_position.y = global_position.y - (1 * delta)
func _on_life_time_timer_timeout() -> void:
	queue_free()
