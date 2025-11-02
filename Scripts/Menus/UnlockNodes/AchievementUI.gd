extends Node

var og_pos;
var target_pos;
var boxHeight;
# Called when the node enters the scene tree for the first time.
func Init(spawnPos : Vector2) -> void:
	#In godot, control nodes always have pivot top left, we have to manually change that
	var heightOffset = 8;
	boxHeight = $StakesSA.size.y;
	var boxWidthHalf = $StakesSA.size.x/2;
	spawnPos = spawnPos - Vector2(boxWidthHalf, -heightOffset);
	self.global_position = spawnPos - Vector2(0, boxHeight); #Spawn it outside the screen
	og_pos = self.global_position;
	target_pos = spawnPos;
	TweenToNewPos(target_pos)
	pass # Replace with function body.

func TweenToNewPos(target_pos : Vector2) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	var tweenDuration = 0.4;
	tween.tween_property(self, "global_position", target_pos, tweenDuration);
	tween.tween_callback(TweenBackToOGPos.bind(og_pos)).set_delay(2.0)
	#set_meta("current_tween", tween);

func TweenBackToOGPos(target_pos : Vector2) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR);
	var tweenDuration = 0.4;
	tween.tween_property(self, "global_position", target_pos, tweenDuration);
	tween.tween_callback(queue_free);
	pass
