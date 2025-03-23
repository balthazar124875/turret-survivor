extends BaseOrb

class_name IceOrb

@export var iceBallVfx : PackedScene

var spawnTimer = 5.0
var currTimer = 0.0

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			HitEnemy(body, delta);

func HitEnemy(body, delta) -> void:
	#TODO: Slow enemies
	body.take_damage(damage_per_tick * delta * player.damageMultiplier)
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	currTimer += delta
	if(currTimer >= spawnTimer):
		currTimer = 0.0
		var iceball = iceBallVfx.instantiate()
		get_tree().root.add_child(iceball)
		iceball.global_position = global_position
		var direction = Vector2(iceball.global_position - player.global_position).normalized()
		var damage = 0.0
		var speed = 250.0
		var lifetime = 7.0
		iceball.init_with_direction(direction, damage, speed, lifetime)
		iceball.pierce = 1000
		
		#TODO: Add velocity and rotation
		iceball.rotation = direction.angle() - PI;
	
