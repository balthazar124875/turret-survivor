extends BaseGun

class_name PoisonNova

@export var particle_effect: PackedScene
@onready var area2d = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

@export var base_radius = 230

var poison_duration = 4
var poison_magnitude = 1

func shoot(enemy: Node) -> void:
	poison_enemies_in_collider()
	collision_shape.shape.radius = base_radius * player.areaSizeMultiplier
	var new_particles = particle_effect.instantiate()
	add_child(new_particles)
	
func apply_level_up():
	if(level == 5):
			poison_magnitude += 2
			return
	if(level == 10):
			poison_duration += 2
			return
	
	match level % 5:
		1:
			base_radius += 20
		2:
			cooldown *= 0.95
		3:
			poison_duration += 1
		4:
			poison_magnitude += 1

func poison_enemies_in_collider():
	var enemies = []
	for body in area2d.get_overlapping_bodies():
		if body is Enemy:  # Check if it's an enemy
			var poisonEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED, poison_duration, poison_magnitude)
			body.apply_status_effect(poisonEffect)
