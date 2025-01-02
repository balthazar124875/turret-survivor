extends Node

class_name Upgrade

enum UpgradeType {
	WEAPON,
}

var upgradeName : String;
var description : String;
var type : UpgradeType;


# Constructor
func _init(name : String):
	upgradeName = name;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
