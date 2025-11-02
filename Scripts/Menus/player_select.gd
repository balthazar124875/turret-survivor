extends Node

class_name PlayerSelectNode

@export var playerName : String;
var objectName : String; #Same as playerName
@export var startAugments : Array[PackedScene]; #res://Scenes/Upgrades/Augments/
@export var startWeapons : Array[PackedScene];
var isLocked : bool;
@export var unlockCondition : String;
@export var sprite : Texture2D;
var curr_angle : float;
var pivotPos : Vector2;
var radius : float;
var stakesCleared : int = 0;
var playerID : int = 0; #IMPORTANT: Give each player a unique ID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isLocked = true;
	curr_angle = 0.0;
	pivotPos = Vector2(0.0, 0.0);
	radius = 0.0;
	objectName = playerName;
	pass # Replace with function body.

func TweenToNewAngle(target_angle : float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE);
	var tweenDuration = 0.2;
	target_angle = lerp_angle(curr_angle, target_angle, 1);
	tween.tween_property(self, "curr_angle", target_angle, tweenDuration);
	#tween.tween_callback($Sprite.queue_free)
	#set_meta("current_tween", tween);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_position = pivotPos + Vector2(cos(curr_angle), sin(curr_angle))*radius;
	self.global_position = target_position;
	pass
