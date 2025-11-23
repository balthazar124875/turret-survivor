extends ArcProjectile

class_name PoisonBlobProjectile

var damage = 1
var base_explosion_size = 100

@onready var player = get_node("/root/EmilScene/Player")
@onready var sprite = $Sprite2D
var splat_particles = preload("res://Scenes/Particles/PoisonSplatParticle.tscn")
func _ready() -> void:
	init_arc(start_pos, target_pos, speed)
	var original_scale = $Sprite2D.scale
	var scale_tween = get_tree().create_tween().set_loops()
	scale_tween.tween_property($Sprite2D, "scale", original_scale + Vector2(0.7, 0.7), 0.3).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property($Sprite2D, "scale", original_scale, 0.3).set_trans(Tween.TRANS_SINE)

func create_explosion():
	var new_particle = splat_particles.instantiate()
	new_particle.global_position = global_position
	get_node("/root/EmilScene/ParticleNode").add_child(new_particle)
	$CollisionShape2D.shape.radius = base_explosion_size * player.areaSizeMultiplier
	damage_enemies_in_collider()

func land():
	landed = true
	create_explosion()
	queue_free()
	
func damage_enemies_in_collider():
	var enemies = []
	for body in get_overlapping_bodies():
		if body is Enemy:  # Check if it's an enemy
			var poisonEffect = StatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED, 5, 1)
			body.apply_status_effect(poisonEffect)
