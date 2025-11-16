extends Node2D

var targets : Array[Node] = []
var life_time: float
@export var thunder: Line2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	thunder.clear_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var i = 1
	for enemy in targets:
		if is_instance_valid(enemy):
			thunder.set_point_position(i, enemy.global_position)
			thunder.set_point_position(i+1, enemy.global_position)
		i += 2

func set_targets(targets) -> void:
	self.targets = targets
	thunder.clear_points()
	thunder.add_point(Vector2(0, 0))
	for enemy in targets:
		thunder.add_point(enemy.global_position)
		thunder.add_point(enemy.global_position)
