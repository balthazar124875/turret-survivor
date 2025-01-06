extends Node2D

var animPlayer;
var aliveTime = 2.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = $AnimationPlayer;
	call_deferred("_delete_after_time", aliveTime)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	animPlayer.play("end_animation")
	await get_tree().create_timer(0.6).timeout
	queue_free()
