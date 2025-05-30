extends Area2D

var animPlayer;
var aliveTime = 0.2;
var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = $AnimationPlayer;
	call_deferred("_delete_after_time", aliveTime)
	animPlayer.play("start_animation")
	
	if(damage != null):
		connect("body_entered", _on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body):
	if body is Enemy and body.is_alive():  # Replace with your enemy script class name
		body.take_hit(damage, "Corpse Explosion", GlobalEnums.DAMAGE_TYPES.FIRE) 
			
func set_particle_scale(scale: float):
	$GPUParticles2D.process_material.scale_min = scale
	$GPUParticles2D.process_material.scale_max = scale
	
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	animPlayer.play("end_animation")
	await get_tree().create_timer(0.6).timeout
	queue_free()
