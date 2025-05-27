extends Node

class_name PlayerSelectNode

@export var playerName : String;
var startingAugments : Array[AugmentUpgrade];
var isLocked : bool;
@export var unlockCondition : String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isLocked = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
