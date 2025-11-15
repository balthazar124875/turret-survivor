extends Node

var characters : Array;
var totalNrOfCharacters : int;
var currentSelectedIdx : int;
var selectedPlayer;

#UI
var nameLabel : Control;
var unlockConditionLabel : Control;
var startAugmentsUI : Array;
@export var spellDescNode : PackedScene;
var augmentStatsControl : Control;
var currStakeID : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characters = $Characters.get_children();
	nameLabel = $Control/NameLabel;
	unlockConditionLabel = $Control/UnlockConditionLabel;
	augmentStatsControl = $Control/Stats/AugmentStats;
	var startPlayerIdx = 0;
	totalNrOfCharacters = characters.size();
	RenderPlayers(startPlayerIdx, false);
	pass # Replace with function body.

func RenderPlayers(startIdx : int, tweening : bool):
	currentSelectedIdx = startIdx;
	currentSelectedIdx = currentSelectedIdx % characters.size();
	var pivotPos = $Characters.global_position;
	var radius = 200;
	var angleStep = deg_to_rad(360.0 / characters.size());
	var startAngle = deg_to_rad(90.0);
	for idx in characters.size():
		var currIdx = (idx + currentSelectedIdx) % characters.size();
		if !tweening:
			characters[currIdx].pivotPos = pivotPos;
			characters[currIdx].radius = radius;
			characters[currIdx].curr_angle = startAngle + angleStep*idx;
			characters[currIdx].global_position = pivotPos + Vector2(cos(startAngle + angleStep*idx), sin(startAngle + angleStep*idx))*radius;
		else:
			var target_angle = startAngle + angleStep*idx;
			characters[currIdx].TweenToNewAngle(target_angle);
			
	selectedPlayer = characters[currentSelectedIdx] as PlayerSelectNode;
	nameLabel.text = selectedPlayer.playerName;
	if selectedPlayer.isLocked:
		nameLabel.text = "[center]???[/center]";
		unlockConditionLabel.visible = true;
		augmentStatsControl.visible = false;
		unlockConditionLabel.text = selectedPlayer.unlockCondition;
	else:
		unlockConditionLabel.visible = false;
		augmentStatsControl.visible = true;
		RenderStartSpellsList(selectedPlayer);
	
	#Make locked characters black
	for idx in characters.size():
		var animated_sprite = characters[idx].get_node("AnimatedSprite2D");
		var currPlayer = characters[idx] as PlayerSelectNode;
		if currPlayer.isLocked:
			animated_sprite.modulate = Color(0.1, 0.1, 0.1, 1)
		else:
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE);
			var tweenDuration = 0.2;
			var target_color = Color(0.5, 0.5, 0.5, 1.0);
			if currPlayer == selectedPlayer:
				target_color = Color(1.0, 1.0, 1.0, 1.0);
			tween.tween_property(animated_sprite, "modulate", target_color, tweenDuration);

func RenderStartSpellsList(player : PlayerSelectNode) -> void:
	for elem in startAugmentsUI:
		elem.queue_free();
	startAugmentsUI.clear();
	
	var startAugments =  player.startAugments;
	var idx = 0;
	for augment in startAugments:
		var spellDescNode = spellDescNode.instantiate();
		var augmentScript = augment.instantiate() as AugmentUpgrade;
		spellDescNode.get_node("SpellName").text = augmentScript.upgradeName;
		spellDescNode.get_node("SpellDesc").text = augmentScript.description;
		spellDescNode.get_node("Icon").texture = augmentScript.icon;
		startAugmentsUI.push_back(spellDescNode);
		augmentStatsControl.add_child(spellDescNode);
		spellDescNode.global_position.y += 120 * idx;
		idx = idx + 1;
		
	var startWeapons =  player.startWeapons;
	for weapon in startWeapons:
		var spellDescNode = spellDescNode.instantiate();
		var weaponUpdgradeScript = weapon.instantiate() as WeaponUpgrade;
		spellDescNode.get_node("SpellName").text = weaponUpdgradeScript.upgradeName;
		spellDescNode.get_node("SpellDesc").text = weaponUpdgradeScript.description;
		spellDescNode.get_node("Icon").texture = weaponUpdgradeScript.icon;
		startAugmentsUI.push_back(spellDescNode);
		augmentStatsControl.add_child(spellDescNode);
		spellDescNode.global_position.y += 120 * idx;
		idx = idx + 1;

func ShiftLeft() -> void:
	RenderPlayers(currentSelectedIdx - 1, true)
	pass
	
func ShiftRight() -> void:
	RenderPlayers(currentSelectedIdx + 1, true)
	pass

func SelectCharacter() -> void:
	if !selectedPlayer.isLocked:
		currStakeID = $Control/Stakes.currIdx;
		var new_scene = load("res://Scenes/simon_ek_scene.tscn").instantiate()
		new_scene.set_player_init_data(selectedPlayer.duplicate(), currStakeID)
		var currScene = get_tree().current_scene;
		get_tree().root.add_child(new_scene);
		get_tree().current_scene = new_scene;
		currScene.call_deferred("free");
	else:
		$Camera2D.start_shake(20);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		ShiftLeft();
	if Input.is_action_just_pressed("move_right"):
		ShiftRight();
	if Input.is_action_just_pressed("confirm"):
		SelectCharacter();
	pass
