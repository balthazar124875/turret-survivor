extends RichTextLabel


var number: float
var initial_y: float
var initial_scale_x: float
var initial_scale_y: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#text = "%.1f" % number
	text = str(ceil(number))
	initial_y = global_position.y
	initial_scale_x = scale.x
	initial_scale_y = scale.y
	rotation_degrees = randf_range(-10, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var modifier = sin(PI * ($LifeTimeTimer.wait_time - $LifeTimeTimer.time_left) / $LifeTimeTimer.wait_time)
	
	# 75 for y-distance and 0.2 for the exponent was just a random number i picked, feel free to change
	scale.x = modifier * (initial_scale_x + pow(number, 0.2))
	scale.y = scale.x
	global_position.y = initial_y - modifier * 75

func _on_life_time_timer_timeout() -> void:
	queue_free()
