extends Area2D

@export var starSign : PackedScene;
@export var starExplosion : PackedScene;

var starSignInstance;
var shootingStarSpeed = 0.75;
var distanceFromGoal = 3.0;
var goalPos;
var damage = 15.0
var damage_max_health_percent = 20.0
var source = "Shooting Star"
@onready var player_damage_mult = get_node("/root/EmilScene/Player").damageMultiplier

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
		damage_enemies_in_collider();
		CreateStarExplosion();
		starSignInstance.queue_free();
		queue_free();
	pass
	
func damage_enemies_in_collider():
	var enemies = []
	var random_damage_type = randi_range(0, GlobalEnums.DAMAGE_TYPES.size() - 1)
	for body in get_overlapping_bodies():
		if body is Enemy:  
			body.take_hit(damage * player_damage_mult + damage_max_health_percent, source, random_damage_type)
			
