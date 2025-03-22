extends BaseGun

class_name BaseOrb

var orbRange = 0.0; #10 feets away from player
var currAngle = 0.0;
var nextAngle = 0.0;
var nextPos;
var orbSpeed = 1.0;
var damage_per_tick = 50;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../..")
	player.addPlayerBaseOrb(self);
	var screenSize = get_viewport().get_visible_rect().size;
	orbRange = screenSize.y*0.10; #10% of the screenSize, to make this scale properly
	pass # Replace with function body.

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			HitEnemy(body, delta);

func HitEnemy(body, delta) -> void:
	body.take_damage(damage_per_tick * delta * player.damageMultiplier)
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = Vector2(1, 1) * player.areaSizeMultiplier
	currAngle = currAngle + delta * orbSpeed * player.projectileSpeedMultipler;
	var orbPos = Vector2(cos(currAngle), sin(currAngle))*orbRange * player.rangeMultiplier;
	orbPos += player.global_position;
	global_position = orbPos;
