extends Node2D

class_name Circle

enum CircleType {
	INNER,
	OUTER
}

var circleUpgrades : Array = [Node2D];
var player;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/EmilScene/Player");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func AddCircleBuff(circle : CircleType, upgrade : Node2D) -> void:
	circleUpgrades[circle].push_back(upgrade);
