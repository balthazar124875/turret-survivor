extends BaseGun

class_name BaseOrb

var type : OrbHandler.OrbTypes;
var orbRange = 0.0; #10 feets away from player
var currAngle = 0.0;
var nextAngle = 0.0;
var nextPos;
var orbSpeed = 1.0;
var damage_per_tick = 1;
var damage_tick_interval : float = 0.5; #Lower value faster tick speed
var effect_multiplier : float = 1.0;

var ogScale;
var ogColliderScale;
var ogDamageTickInterval;

@export var orbEnhanceVfx : PackedScene
var enhancedVfxInstance : Node2D;
var isEnhanced : bool = false;

class RegisteredEnemy:
	var enemy : Enemy;
	var tick : float;
	

var registeredEnemyList : Array[RegisteredEnemy];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#These two will make so all children of BaseOrb connects events for body entered and exit
	$Area2D.body_entered.connect(_on_area_2d_body_entered) #The _on_area_2d_body_entered can be named anything!
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	enemy_parent = get_node("/root/EmilScene/Enemies")
	
	orbEnhanceVfx = load("res://Scenes/vfx/vfx_orb_enhanced.tscn")
	enhancedVfxInstance = orbEnhanceVfx.instantiate();
	add_child(enhancedVfxInstance)
	enhancedVfxInstance.global_position = global_position;
	enhancedVfxInstance.visible = false;
	
	ogScale = $AnimatedSprite2D.scale;
	ogColliderScale = $Area2D/CollisionShape2D.scale;
	ogDamageTickInterval = damage_tick_interval;
	
	player = get_node("../..")
	OrbHandler.addPlayerBaseOrb(self);
	SignalBus.orb_purchased.emit();
	var screenSize = get_viewport().get_visible_rect().size;
	orbRange = screenSize.y*0.10; #10% of the screenSize, to make this scale properly
	
	if OrbHandler.enhancedOrbs[type]:
		EnhanceOrb();
	
	pass # Replace with function body.

#func _physics_process(delta):
#	for body in $Area2D.get_overlapping_bodies():
#		if body is Enemy:
#			HitEnemy(body, delta);

func HitEnemy(body) -> void:
	body.take_hit(damage_per_tick * player.damageMultiplier, source, damage_type);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = Vector2(1, 1) * player.areaSizeMultiplier
	currAngle = currAngle + delta * orbSpeed * player.projectileSpeedMultipler;
	var orbPos = Vector2(cos(currAngle), sin(currAngle))*orbRange;
	orbPos += player.global_position;
	global_position = orbPos;
	
	enhancedVfxInstance.global_position = orbPos;
	
	for regEnemy in registeredEnemyList:
		regEnemy.tick += delta;
		if regEnemy.tick >= damage_tick_interval:
			HitEnemy(regEnemy.enemy);
			regEnemy.tick = 0.0;
		
func ApplyVisualChanges() -> void:
	$AnimatedSprite2D.scale *= 2.0;
	$Area2D/CollisionShape2D.scale *= 2.0;
	pass
	
func ApplyOrbStats(dmg : int, dmg_interval : float, effect_mult : float, scale : float) -> void:
	damage_per_tick = dmg;
	damage_tick_interval = ogDamageTickInterval * dmg_interval;
	effect_multiplier = effect_mult;
	$AnimatedSprite2D.scale = ogScale * scale;
	$Area2D/CollisionShape2D.scale = ogColliderScale * scale;
	
	pass

func EnhanceOrb() -> void:
	enhancedVfxInstance.visible = true;
	isEnhanced = true;
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var registeredEnemy = RegisteredEnemy.new();
		registeredEnemy.enemy = body;
		registeredEnemy.tick = 0.0;
		registeredEnemyList.push_back(registeredEnemy);
		HitEnemy(body);
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Enemy:
		for regEnemy in registeredEnemyList:
			if regEnemy.enemy == body:
				registeredEnemyList.erase(regEnemy);
				return;
	pass # Replace with function body.
