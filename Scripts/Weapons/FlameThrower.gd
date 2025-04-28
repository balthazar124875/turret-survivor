extends BaseGun

class_name FlameThrower

@export var flameThrowerVfx : PackedScene
var flame_thrower_instance : Node2D
var ftParticles : GPUParticles2D
var IsShooting : bool;
var targettedEnemy : Node2D;

@onready var flameCollider;
var areaSizeMultiplierScale = 0.375;
var activeFlameColliders : Array[Node] = [];
var flameRange = 0.6
var flameColRange = 0.6
var maxFlameRange = 4.0;
var ogFlameRange = 0.6;
var ogParticleScale = 1.0;
var currentMinParticleScale = 1.0;
var finalFlameScale = 1.0;
var spread_angle = 20.0;

func _ready() -> void:
	super()
	IsShooting = false;
	spread_angle = 20.0;
	SignalBus.stat_updated.connect(IncreaseFlameAreaSizeMultiplier)
	targettedEnemy = null;
	
	flame_thrower_instance = flameThrowerVfx.instantiate();
	add_child(flame_thrower_instance)
	flame_thrower_instance.global_position = player.global_position;
	ftParticles = flame_thrower_instance.get_node("GPUParticles2D");
	ftParticles.global_position = player.global_position;
	ogParticleScale = ftParticles.process_material.scale;
	currentMinParticleScale = ogParticleScale;
	finalFlameScale = ogParticleScale;
	
	CreateFlameColliderInstance();
	StopFlameThrowerVfx();
	pass
	
func _process(delta: float) -> void:
	if(!IsShooting):
		var enemy = get_target();
		if(enemy):
			targettedEnemy = enemy;
			IsShooting = true;
			PlayFlameThrowerVfx(enemy);
	elif(targettedEnemy == null):
		IsShooting = false;
		StopFlameThrowerVfx();
	UpdateFlameColliderPoints();
	pass

func CreateFlameColliderInstance() -> void:
	#TODO: Create a new flameCollider instance and store in list
	flameCollider = flame_thrower_instance.get_node("Area2D").get_node("CollisionPolygon2D");
	UpdateFlameAreaSize()

func UpdateFlameColliderPoints() -> void:
	var colRange = flameColRange * 250;
	var half_width = colRange * tan(deg_to_rad(spread_angle) / 2)
	var points = [
		Vector2(0, -half_width*0.5),           # Top-left
		Vector2(colRange, -half_width*1.1),    # Top-right
		Vector2(colRange, half_width*1.1),     # Bottom-right
		Vector2(0, half_width*0.5)             # Bottom-left
	]
	flameCollider.polygon = points
	pass

func IncreaseFlameAreaSizeMultiplier(stat: GlobalEnums.PLAYER_STATS, new_total: float, increase: float) -> void:
	if(stat == GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER):
		UpdateFlameAreaSize()

func UpdateFlameAreaSize() -> void:
	var multiplier = (player.areaSizeMultiplier - 1.0) * areaSizeMultiplierScale + 1.0;
	spread_angle = 20 + (multiplier - 1.0)*15; #Increase this with scale increase
	finalFlameScale = currentMinParticleScale * multiplier;
	ftParticles.process_material.scale = finalFlameScale;

func PlayFlameThrowerVfx(enemy : Node2D) -> void:
	#Rotate properly
	var direction = Vector2(enemy.global_position - player.global_position).normalized();
	ftParticles.rotation = direction.angle();
	flameCollider.rotation = direction.angle();
	ftParticles.emitting = true;
	pass
	
func StopFlameThrowerVfx() -> void:
	ftParticles.emitting = false;
	pass
	
#adjust the flamethrower vfx visuals based on range
func IncreaseFlameThrowerRange(range : float) -> void:
	flameRange += range;
	if(flameRange >= maxFlameRange):
		flameRange = maxFlameRange;
		
	ftParticles.scale = Vector2(flameRange, flameRange);
	var rangeRatio : int = flameRange / ogFlameRange;

	#Increase amount of particles
	ftParticles.amount = 100*rangeRatio;
	flameColRange = flameRange*0.9;
	pass
	
func apply_level_up():
	
	if(level > 10):
		damage *= 1.2;
		return;
	
	if(level == 5):
		currentMinParticleScale *= 2.0
		UpdateFlameAreaSize()
		IncreaseFlameThrowerRange(0.5);
		damage *= 1.5
		return
	if(level == 10):
		#ftParticles.scale += Vector2(1.0,1.0);
		#ftParticles.amount += 100;
		currentMinParticleScale *= 1.5
		UpdateFlameAreaSize()
		IncreaseFlameThrowerRange(0.5);
		damage *= 2.0
		return
	
	match level % 5:
		1:
			damage *= 1.5
		2:
			IncreaseFlameThrowerRange(0.5);
			#ftParticles.scale += Vector2(0.5,0.5);
			#ftParticles.amount += 75;
		3:
			damage *= 1.5
		4:
			IncreaseFlameThrowerRange(0.5);
			#ftParticles.scale += Vector2(0.5,0.5);
			#ftParticles.amount += 75;
