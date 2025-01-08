extends Node2D

var targets : Array[Node] = []
var life_time: float
@export var thunder: Line2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thunder.clear_points()
	thunder.add_point(Vector2(0, 0))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	thunder.clear_points()
	thunder.add_point(Vector2(0, 0))
	for enemy in targets:
		if is_instance_valid(enemy):
			thunder.add_point((enemy.global_position - self.global_position))
	pass

func set_targets(targets: Array[Node]) -> void:
	self.targets = targets
