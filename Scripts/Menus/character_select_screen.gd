extends Node

var characters : Array;
var totalNrOfCharacters : int;
var currentSelectedIdx : int;

#UI
var nameLabel : Control;
var startAugments;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characters = $Characters.get_children();
	nameLabel = $Control/NameLabel;
	var startPlayerIdx = 0;
	totalNrOfCharacters = characters.size();
	RenderPlayers(startPlayerIdx);
	pass # Replace with function body.

func RenderPlayers(startIdx : int):
	currentSelectedIdx = startIdx;
	currentSelectedIdx = currentSelectedIdx % characters.size();
	var pivotPos = $Characters.global_position;
	var radius = 200;
	var angleStep = deg_to_rad(360.0 / characters.size());
	var startAngle = deg_to_rad(90.0);
	for idx in characters.size():
		var currIdx = (idx + currentSelectedIdx) % characters.size();
		characters[currIdx].global_position = pivotPos + Vector2(cos(startAngle + angleStep*idx), sin(startAngle + angleStep*idx))*radius;
	
	var selectedPlayer = characters[currentSelectedIdx] as PlayerSelectNode;
	nameLabel.text = selectedPlayer.playerName;
	if selectedPlayer.isLocked:
		var animated_sprite = characters[currentSelectedIdx].get_node("AnimatedSprite2D");
		animated_sprite.modulate = Color(0.1, 0.1, 0.1, 1)
		nameLabel.text = "[center]???[/center]";

func ShiftLeft() -> void:
	RenderPlayers(currentSelectedIdx - 1)
	pass
	
func ShiftRight() -> void:
	RenderPlayers(currentSelectedIdx + 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		ShiftLeft();
	if Input.is_action_just_pressed("move_right"):
		ShiftRight();
	pass
