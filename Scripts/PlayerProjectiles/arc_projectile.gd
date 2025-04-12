extends Area2D

class_name ArcProjectile

var start_pos: Vector2
var target_pos: Vector2

var path: Path2D
var path_follow: PathFollow2D

var speed = 300

var landed = false

var arc_height: float  = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta) -> void:
	if (landed):
		return
	if path_follow.progress_ratio >= 1:
		land()
		
	path_follow.progress += speed * delta
	position = path_follow.position
	
func init_arc(start_pos: Vector2, target_pos: Vector2, speed: float):
	self.global_position = start_pos
	self.start_pos = start_pos
	self.target_pos = target_pos
	self.speed = speed
	create_curve()
	
func create_curve():
	path = Path2D.new()
	path_follow = PathFollow2D.new()
	
	var curve = Curve2D.new()
	curve.add_point(start_pos)
	curve.add_point((start_pos + target_pos) / 2 - Vector2(0, arc_height))  # Arc control point
	curve.add_point(target_pos)
	
	path_follow.loop = false
	path.curve = curve
	add_child(path)
	path.add_child(path_follow)
	
	path.curve.set_point_out(0, Vector2(target_pos.x / 2, -abs(target_pos.x)))
	path.curve.set_point_position(1, target_pos)
	
	
func land() -> void:
	landed = true
	pass
