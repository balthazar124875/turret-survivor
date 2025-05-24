extends Area2D

var flameMaxRange;
var currFlameRange;
var innerPtsOffset; #The pts starting at player pos, these will grow as the flame turns off and closes
var outerGrowSpeed;
var innerGrowSpeed; #Should be slightly slower than outer grow speed
var isGrowing;
var spread_angle;
var speedScale;

#Lower value here makes the cone shape sharper
#We want to increase this value towards 1 as the flame turns off
var coneShapeIntensityScale = 0.5;
var minConeShapeIntensity = 0.5;
var damage = 0.0;

var collider : CollisionPolygon2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true
	monitorable = true;
	outerGrowSpeed = 0.55;
	innerGrowSpeed = 0.4;
	speedScale = 1.0;
	coneShapeIntensityScale = 0.5;
	minConeShapeIntensity = 0.5;
	currFlameRange = 0.0;
	isGrowing = true;
	innerPtsOffset = 0.0;
	collider = get_node("CollisionPolygon2D");
	collider.disabled = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#ProcessPerFrameData(delta)
	pass
	
func ProcessPerFrameData(delta: float) -> void:
	#This will make sure our collider outer points are growing
	currFlameRange += outerGrowSpeed * delta * speedScale;
	if(currFlameRange >= flameMaxRange):
		currFlameRange = flameMaxRange;
		
	#This will make the inner points (pts close to player) close in.
	if !isGrowing:
		innerPtsOffset += innerGrowSpeed * delta * speedScale;
		var ratio = innerPtsOffset / flameMaxRange; #If ratio 1 it means the inner has reached outer and collider has disappeared
		#Interpolate
		coneShapeIntensityScale = minConeShapeIntensity * (1 - ratio) + 1.0 * ratio;
	
	if innerPtsOffset >= flameMaxRange:
		queue_free(); #Destroy when the collider fully disappears which happens when the flame disappears
	
	#UpdateSingleFlameColliderPoints()
	pass

func init(maxFlameRange : float, spreadAngle : float, flameDamage : float, emitterScaleIncrease : float) -> void:
	flameMaxRange = maxFlameRange;
	spread_angle = spreadAngle;
	damage = flameDamage;
	speedScale *= emitterScaleIncrease; #The particle speed become faster as the scale increase
	pass

func UpdateData(maxFlameRange : float, spreadAngle : float, flameDamage : float, emitterScaleIncrease : float) -> void:
	init(maxFlameRange, spreadAngle, flameDamage, emitterScaleIncrease);
	pass
	
func TurnOff() -> void:
	isGrowing = false;

func UpdateSingleFlameColliderPoints() -> void:
	var colRange = currFlameRange * 250;
	var half_width = colRange * tan(deg_to_rad(spread_angle) / 2)
	var innerPts = innerPtsOffset * 250;
	var points = [
		Vector2(innerPts, -half_width*coneShapeIntensityScale), # Top-left
		Vector2(colRange, -half_width*1.1),       # Top-right
		Vector2(colRange, half_width*1.1),        # Bottom-right
		Vector2(innerPts, half_width*coneShapeIntensityScale)   # Bottom-left
	]
	collider.polygon = points;
	collider.disabled = false #This is apparently needed to make Godot refresh the shape for collision check
	#Also super important after refreshing the collider:
	#YOU MUST Wait at least one physics frame before checking for overlaps
	#For this you need to use await get_tree().physics_frame.
	#await get_tree().physics_frame
	#await Engine.get_main_loop().process_frame
	#await get_tree().process_frame

func HitEnemy(body) -> void:
	body.take_hit(damage*100.0, "Flamethrower", GlobalEnums.DAMAGE_TYPES.FIRE)

func _physics_process(delta):
	ProcessPerFrameData(delta);
	UpdateSingleFlameColliderPoints();

func _on_body_entered(body: Node2D) -> void:
	#TODO: Store enemies in a list and make them take tick damage
	if body is Enemy:
		HitEnemy(body);
	pass # Replace with function body.
