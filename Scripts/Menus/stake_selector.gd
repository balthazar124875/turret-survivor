extends Control

class_name StakeSelector;

var stakeIcons : Array[Texture2D];
var stakeDescription : Control;
var currIdx : int = 0;
var maxIdx = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stakeDescription = $StakeDescription;
	SetStakeDescription(0);
	pass # Replace with function body.

func SetStakeDescription(increment : int) -> void:
	var text = "";
	currIdx = currIdx + increment;
	if currIdx < 0:
		currIdx = 0;
	if currIdx > maxIdx:
		currIdx = maxIdx;
	
	stakeDescription.text = str(currIdx)+" - ";
	
	match currIdx:
		0:
			stakeDescription.text = "No stakes."
			return;
		1:
			stakeDescription.text += "New enemy types appear." #Enemy stealing money? Ghost enemy?
			return;
		2:
			text = "Locked slots."
		3:
			text = "Stronger enemies and more elites."
		4:
			text = "Cursed store." #Force frozen slots, items can give debuffs, more expensive items sometimes.
		5:
			text = "Boss arrives much earlier."
	
	text += "\nAll previous stakes also apply."
	stakeDescription.text += text;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_right_sub"):
		SetStakeDescription(+1);
	if Input.is_action_just_pressed("move_left_sub"):
		SetStakeDescription(-1);
	pass
