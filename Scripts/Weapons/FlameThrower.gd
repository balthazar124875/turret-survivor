extends BaseGun

class_name FlameThrower

@export var flameThrowerVfx : PackedScene
@export var flameCollider : PackedScene
var flame_thrower_instance : Node2D
var ftParticles : GPUParticles2D
var IsShooting : bool;
var targettedEnemy : Node2D;

var areaSizeMultiplierScale = 0.375;
var enemy_to_flameColliders_hashMap = {};
var deadFlameColliders = []; #Colliders that are about to die, will shrink and get deleted
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
	SignalBus.enemy_killed.connect(DestroyFlameColliderInstance)
	targettedEnemy = null;
	
	flame_thrower_instance = flameThrowerVfx.instantiate();
	add_child(flame_thrower_instance)
	flame_thrower_instance.global_position = player.global_position;
	ftParticles = flame_thrower_instance.get_node("GPUParticles2D");
	ftParticles.global_position = player.global_position;
	ogParticleScale = ftParticles.process_material.scale;
	currentMinParticleScale = ogParticleScale;
	finalFlameScale = ogParticleScale;
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
	pass

func CreateFlameColliderInstance(enemyHash : Enemy, directionAngle : float) -> void:
	#TODO: Create a new flameCollider instance and store in list
	var flameColliderInst = flameCollider.instantiate();
	flame_thrower_instance.add_child(flameColliderInst);
	flameColliderInst.rotation = directionAngle;
	flameColliderInst.init(flameColRange, spread_angle, damage, flameRange / ogFlameRange);
	enemy_to_flameColliders_hashMap[enemyHash] = flameColliderInst;

func DestroyFlameColliderInstance(enemyHash: Enemy) -> void:
	var flameCollider = enemy_to_flameColliders_hashMap.get(enemyHash, null)
	if flameCollider:
		enemy_to_flameColliders_hashMap.erase(enemyHash);
		flameCollider.TurnOff() #Will automatically shrink and free the collider.
	pass
		
func IncreaseFlameAreaSizeMultiplier(stat: GlobalEnums.PLAYER_STATS, new_total: float, increase: float) -> void:
	if(stat == GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER):
		UpdateFlameAreaSize()

func UpdateFlameAreaSize() -> void:
	var multiplier = (player.areaSizeMultiplier - 1.0) * areaSizeMultiplierScale + 1.0;
	spread_angle = 20 + (multiplier - 1.0)*15; #Increase this with scale increase
	finalFlameScale = currentMinParticleScale * multiplier;
	ftParticles.process_material.scale = finalFlameScale;
	UpdateCollidersData()

#Send the new flame range and spread_angle to the colliders
func UpdateCollidersData() -> void:
	for enemyHash in enemy_to_flameColliders_hashMap:
		var flameCollider = enemy_to_flameColliders_hashMap[enemyHash];
		flameCollider.UpdateData(flameColRange, spread_angle, damage, flameRange / ogFlameRange);
	pass
	
#adjust the flamethrower vfx visuals based on range
func IncreaseFlameThrowerRange(range : float) -> void:
	flameRange += range;
	if(flameRange >= maxFlameRange):
		flameRange = maxFlameRange;
		
	ftParticles.scale = Vector2(flameRange, flameRange);
	var rangeRatio : int = flameRange / ogFlameRange; #How many percentage did the range increase with?

	#Increase amount of particles
	ftParticles.amount = 100*rangeRatio;
	flameColRange = flameRange*0.9;
	#TODO: We might need to destroy all active colliders since updating scale resets the animation
	UpdateCollidersData()
	pass

func PlayFlameThrowerVfx(enemy : Node2D) -> void:
	#Rotate properly
	var direction = Vector2(enemy.global_position - player.global_position).normalized();
	ftParticles.rotation = direction.angle();
	ftParticles.emitting = true;
	CreateFlameColliderInstance(enemy, direction.angle());
	pass
	
func StopFlameThrowerVfx() -> void:
	ftParticles.emitting = false;
	pass
	
func apply_level_up():
	
	if(level > 10):
		damage *= 1.2;
		UpdateCollidersData()
		return;
	
	if(level == 5):
		currentMinParticleScale *= 2.0
		UpdateFlameAreaSize()
		IncreaseFlameThrowerRange(0.5);
		damage *= 1.5
		UpdateCollidersData()
		return
	if(level == 10):
		currentMinParticleScale *= 1.5
		UpdateFlameAreaSize()
		IncreaseFlameThrowerRange(0.5);
		damage *= 2.0
		UpdateCollidersData()
		return
	
	match level % 5:
		1:
			damage *= 1.5
		2:
			IncreaseFlameThrowerRange(0.5);
		3:
			damage *= 1.5
		4:
			IncreaseFlameThrowerRange(0.5);
			
	UpdateCollidersData()
