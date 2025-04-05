extends Node2D

var animPlayer;
var aliveTime = 0.2;
var damage_per_tick = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = $AnimationPlayer;
	call_deferred("_delete_after_time", aliveTime)
	animPlayer.play("start_animation")
	pass # Replace with function body.

func _physics_process(delta):
	#for body in $Area2D.get_overlapping_bodies():
	#	if body is Enemy:
	#		body.take_damage(damage_per_tick * delta)
	pass

func set_particle_scale(scale: float):
	$GPUParticles2D.process_material.scale_min = scale
	$GPUParticles2D.process_material.scale_max = scale
	
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	animPlayer.play("end_animation")
	await get_tree().create_timer(0.6).timeout
	queue_free()
