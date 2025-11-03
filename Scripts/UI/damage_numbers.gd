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
	GlobalEnums.DAMAGE_TYPES.FIRE: "orange",
	GlobalEnums.DAMAGE_TYPES.POISON: "green",
	GlobalEnums.DAMAGE_TYPES.LIGHTNING: "yellow"
}

var time_since_change: float = 0
var duration = 0.75
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#text = "%.1f" % number
	text = "[color=" + damage_type_colors[damage_type] +"]" + String.num(ceil(number), 0) + "[/color]"
	initial_y = global_position.y
	initial_scale_x = scale.x
	initial_scale_y = scale.y
	rotation_degrees = randf_range(-10, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	time_since_change += delta
	
	if(t >= duration):
		queue_free()
		return
	
	var modifier = sin(PI * (t) / duration)
	
	# 75 for y-distance and 0.2 for the exponent was just a random number i picked, feel free to change
	scale.x = modifier * (initial_scale_x + pow(number, 0.2))
	scale.y = scale.x
	global_position.y = initial_y - modifier * 75

func update_number(number: float):
	self.number = number
	
	if(t > duration/2):
		t = duration/2
	time_since_change = 0
	text = "[color=" + damage_type_colors[damage_type] +"]" + String.num(ceil(number), 0) + "[/color]"
#
#func _on_life_time_timer_timeout() -> void:
	#queue_free()
