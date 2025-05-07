extends Bullet

class_name BasicSwordProjectile

@onready var player_position = get_node("/root/EmilScene/Player").global_position

var swing_degrees: float
var sword_scale: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	SignalBus.bullet_created.emit(self)
	scale = Vector2(0,0)
	disableHitbox()
	rotation_degrees = rotation_degrees - swing_degrees * 0.5
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(sword_scale, sword_scale), 0.5).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(enableHitbox)
	tween.tween_property(self, "rotation", deg_to_rad(self.rotation_degrees + swing_degrees), 1).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(disableHitbox)
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(queue_free)
	
	
func disableHitbox(): 
	$CollisionShape2D.scale = Vector2(0,0)
	
func enableHitbox(): 
	$CollisionShape2D.scale = Vector2(1,1)

func HitEnemy(body : Enemy):
	body.take_damage(damage, source, damage_type)  # Call the enemy's damage function
	for e in effects:
		e.call(body, self)

func _on_body_entered(body):
	if body is Enemy:
		HitEnemy(body)
