extends Node2D

var animPlayer;
@export var aliveTime = 2.0;
var damage_per_second = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = $AnimationPlayer;
	call_deferred("_delete_after_time", aliveTime)
	pass # Replace with function body.

func init(duration: float, damage: float, area: float):
	aliveTime = duration
	damage_per_second = damage
	scale *= area

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			body.take_damage(damage_per_second * delta, "Thunder", GlobalEnums.DAMAGE_TYPES.LIGHTNING)
			
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	animPlayer.play("end_animation")
	await get_tree().create_timer(0.6).timeout
	queue_free()
