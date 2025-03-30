extends BaseGun

class_name BaseOrb

var orbRange = 0.0; #10 feets away from player
var currAngle = 0.0;
var nextAngle = 0.0;
var nextPos;
var orbSpeed = 1.0;
var damage_per_tick = 5;

@export var orbEnhanceVfx : PackedScene
var enhancedVfxInstance : Node2D;
var isEnhanced : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_parent = get_node("/root/EmilScene/Enemies")
	
	orbEnhanceVfx = load("res://Scenes/vfx/vfx_orb_enhanced.tscn")
	enhancedVfxInstance = orbEnhanceVfx.instantiate();
	add_child(enhancedVfxInstance)
	enhancedVfxInstance.global_position = global_position;
	enhancedVfxInstance.visible = false;
	
	player = get_node("../..")
	OrbHandler.addPlayerBaseOrb(self);
	var screenSize = get_viewport().get_visible_rect().size;
	orbRange = screenSize.y*0.15; #10% of the screenSize, to make this scale properly
	pass # Replace with function body.

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			HitEnemy(body, delta);

func HitEnemy(body, delta) -> void:
	body.take_damage(damage_per_tick * delta * player.damageMultiplier, source)
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = Vector2(1, 1) * player.areaSizeMultiplier
	currAngle = currAngle + delta * orbSpeed * player.projectileSpeedMultipler;
	var orbPos = Vector2(cos(currAngle), sin(currAngle))*orbRange;
	orbPos += player.global_position;
	global_position = orbPos;
	
	enhancedVfxInstance.global_position = orbPos;
	
func ApplyVisualChanges() -> void:
	$AnimatedSprite2D.scale *= 2.0;
	$Area2D/CollisionShape2D.scale *= 2.0;
	pass

func EnhanceOrb() -> void:
	enhancedVfxInstance.visible = true;
	isEnhanced = true;
	pass
