extends BaseOrb

class_name ThunderOrb

const MAX_LINES = 10;
const BIG_ORB_EXTRA_LINES = 3; #Extra lines that get added to big orb
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
	
func ApplyVisualChanges() -> void:
	super();
	#Add some extra lines to big orb
	for i in BIG_ORB_EXTRA_LINES:
		var thunder = thunderLine.instantiate();
		add_child(thunder)
		thunderLines.append(thunder)
	var interval = TAU/(MAX_LINES+BIG_ORB_EXTRA_LINES);
	var i = 0;
	for thunder in thunderLines:
		thunder.set_point_position(0, Vector2(0,0))
		#Set the thunder evenly
		var pointPos = Vector2(cos(interval*i), sin(interval*i)) * sphere_radius
		thunder.set_point_position(3, pointPos)	
		i += 1;
	
	sphere_radius *= 2.0
	#Increase size of thunder as well
	i = 0;
	interval = TAU/(MAX_LINES+BIG_ORB_EXTRA_LINES) #TAU=2π
	for thunder in thunderLines:
		var pointPos = Vector2(cos(interval*i), sin(interval*i)) * sphere_radius
		thunder.set_point_position(3, pointPos)	
		thunder.width *= 2.0;
		i += 1;
