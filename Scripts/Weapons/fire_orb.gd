extends BaseGun

class_name FireOrb

var fireOrbRange = 0.0; #10 feets away from player
var startAngle = 0.0;
var orbSpeed = 1.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../..")
	player.addPlayerFireOrb(self);
	var screenSize = get_viewport().get_visible_rect().size;
	fireOrbRange = screenSize.y*0.15; #10% of the screenSize, to make this scale properly
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Rotate fireorb here
	startAngle = startAngle + delta * orbSpeed;
	var orbPos = Vector2(cos(startAngle), sin(startAngle))*fireOrbRange;
	orbPos += player.global_position;
	global_position = orbPos;
