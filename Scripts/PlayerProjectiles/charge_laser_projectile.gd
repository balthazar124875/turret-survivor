extends Node2D

class_name ChargeLaserProjectile

@onready var charge_particles = $ChargeParticles
@onready var laser_area = $LaserArea
@onready var laser_sprite = $Sprite2D
@onready var damage_tick_timer = $Timer

enum ChargeState {CHARGING, DO_DAMAGE, DECHARGE}
var charge_speed = 0.5
var current_charge = 0
var damage_per_tick = 3
var total_ticks = 3
var ticks_done = 0
var tick_wait_time = 0.3
var state = ChargeState.CHARGING
var source: String
var damage_type: GlobalEnums.DAMAGE_TYPES

var range: float
var laser_width = 2.5

func _ready() -> void:
	charge_particles.amount_ratio = 0
	laser_sprite.scale = Vector2(range, 0);
	laser_area.scale = Vector2(range / 2, laser_width)
	damage_tick_timer.wait_time = tick_wait_time
	
func _process(delta: float) -> void:
	match state:
		ChargeState.CHARGING:
			current_charge += charge_speed * delta
			charge_particles.amount_ratio = current_charge
			if current_charge >= 1:
				if laser_sprite.scale.y < laser_width:
					laser_sprite.scale += Vector2(0, 13 * laser_width * delta)
				else:
					damage_enemies_in_collider()
					state = ChargeState.DO_DAMAGE
					damage_tick_timer.start()
		ChargeState.DO_DAMAGE:
			pass
		ChargeState.DECHARGE:
			current_charge -= charge_speed * delta
			charge_particles.amount_ratio = current_charge
			if laser_sprite.scale.y > 0:
				laser_sprite.scale -= Vector2(0, 13 * laser_width * delta)
			else:
				queue_free()

func damage_enemies_in_collider():
	ticks_done += 1
	var enemies = []
	for body in laser_area.get_overlapping_bodies():
		if body is Enemy:  # Check if it's an enemy
			body.take_damage(damage_per_tick, source, damage_type)
	if ticks_done >= total_ticks:
		damage_tick_timer.stop()
		state = ChargeState.DECHARGE

func _on_timer_timeout() -> void:
	damage_enemies_in_collider()
