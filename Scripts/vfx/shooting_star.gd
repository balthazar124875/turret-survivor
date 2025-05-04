extends Node

@export var starSign : PackedScene;
@export var starExplosion : PackedScene;

var starSignInstance;
var shootingStarSpeed = 0.75;
var distanceFromGoal = 3.0;
var goalPos;
var damage = 50.0;

func init(signPos : Vector2) -> void:
	starSignInstance = starSign.instantiate();
	get_tree().root.add_child(starSignInstance);
	starSignInstance.global_position = signPos;
	goalPos = signPos;
	
	#The shooting star itself
	self.global_position = goalPos * distanceFromGoal;
	pass;

func CreateStarExplosion() -> void:
	var starExplInst = starExplosion.instantiate();
	get_tree().root.add_child(starExplInst);
	starExplInst.global_position = goalPos;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	distanceFromGoal = distanceFromGoal - delta * shootingStarSpeed;
	self.global_position = goalPos * distanceFromGoal;
	if(distanceFromGoal <= 1.0):
		distanceFromGoal = 1.0;
		CreateStarExplosion();
		starSignInstance.queue_free();
		queue_free();
	pass
