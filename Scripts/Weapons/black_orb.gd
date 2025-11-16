extends BaseOrb

class_name BlackOrb

const MAX_LINES = 10;
const updateTime = 0.1;
var currTime = 0.0;
var thunderLines: Array[Line2D] = [];
var sphere_radius = 80;
@export var thunderLine : PackedScene;

func _ready() -> void:
	type = OrbHandler.OrbTypes.BLACK;
	super()
	var interval = TAU/MAX_LINES #TAU=2π
	for i in MAX_LINES:
		thunderLines.append(thunderLine.instantiate())
	var i = 0;
	for thunder in thunderLines:
		add_child(thunder)
		thunder.set_point_position(0, Vector2(0,0))
		#Set the thunder evenly
		var pointPos = Vector2(cos(interval*i), sin(interval*i)) * sphere_radius
		thunder.set_point_position(3, pointPos)	
		i += 1;
	pass
	
func _process(delta : float) -> void:
	super(delta)
	currTime += delta;
	if currTime > updateTime:
		UpdateLines();
		currTime = 0;
	pass

func UpdateLines() -> void:
	#var i = 0;
	#var interval = TAU/MAX_LINES #TAU=2π
	for thunder in thunderLines:
		var angle = randf() * TAU # TAU = 2π
		var pointPos = Vector2(cos(angle), sin(angle)) * sphere_radius
		thunder.set_point_position(1, pointPos)	
		thunder.set_point_position(2, pointPos)	
		
		#Will offset the line length by random amount, but it didn't look that good.
		#var distOffset = (randf()*2.0-1.0) * 10; #TAU = 2π
		#pointPos = Vector2(cos(interval*i), sin(interval*i)) * (sphere_radius+distOffset)
		#thunder.set_point_position(3, pointPos)
		#i += 1;
	pass
