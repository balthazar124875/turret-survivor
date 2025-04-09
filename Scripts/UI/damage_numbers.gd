extends RichTextLabel


var number: float
var initial_y: float
var initial_scale_x: float
var initial_scale_y: float
var damage_type: GlobalEnums.DAMAGE_TYPES
var damage_type_colors = {
	GlobalEnums.DAMAGE_TYPES.PHYSICAL: "white",
	GlobalEnums.DAMAGE_TYPES.MAGIC: "purple",
	GlobalEnums.DAMAGE_TYPES.ICE: "cyan",
	GlobalEnums.DAMAGE_TYPES.FIRE: "red",
	GlobalEnums.DAMAGE_TYPES.POISON: "green",
	GlobalEnums.DAMAGE_TYPES.LIGHTNING: "yellow"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#text = "%.1f" % number
	text = "[color=" + damage_type_colors[damage_type] +"]" + str(ceil(number)) + "[/color]"
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

func update_text(number: float, color: String):
	text = "[color=" + color +"]" + str(ceil(number)) + "[/color]"

func _on_life_time_timer_timeout() -> void:
	queue_free()
