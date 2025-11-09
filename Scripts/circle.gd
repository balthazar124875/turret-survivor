extends Node2D

class_name Circle

enum CircleType {
	INNER,
	OUTER
}

static var circleUpgrades : Array = [];
var player;
static var playerPos;
static var circleSprite : Texture; #We use this to get the circle radius
static var CircleSelf : Circle;

static var damage_type_multipliers : Array = [];
static var player_stat_multipliers : Array = []; #Check GlobalEnums.gd for player stat types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/EmilScene/Player");
	CircleSelf = self;
	playerPos = player.global_position;
	UpdateCircleSprite();
	circleUpgrades.append([]) #Inner
	circleUpgrades.append([]) #Outer
	
	damage_type_multipliers.append([]) #Inner
	damage_type_multipliers.append([]) #Outer
	for i in GlobalEnums.DAMAGE_TYPES:
		damage_type_multipliers[CircleType.INNER].push_back(1.0); #1.0 means all multipliers are defaulted to 1.0
		damage_type_multipliers[CircleType.OUTER].push_back(1.0);
		
	player_stat_multipliers.append([]) #Inner
	player_stat_multipliers.append([]) #Outer
	for i in GlobalEnums.DAMAGE_TYPES:
		player_stat_multipliers[CircleType.INNER].push_back(1.0); #1.0 means all multipliers are defaulted to 1.0
		player_stat_multipliers[CircleType.OUTER].push_back(1.0);
		
	pass

func UpdateCircleSprite() -> void:
	#https://www.reddit.com/r/godot/comments/18vw3br/get_current_sprite_of_animatedsprite2d/
	var frameIndex: int = $AnimatedSprite2D.get_frame()
	var animationName: String = $AnimatedSprite2D.animation
	var spriteFrames: SpriteFrames = $AnimatedSprite2D.get_sprite_frames()
	var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
	
	circleSprite = currentTexture
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func AddCircleUpgrade(circleType : CircleType, upgrade : CircleUpgrade) -> void:
	circleUpgrades[circleType].push_back(upgrade);
	UpdateCircleMultipliers(circleType, upgrade);

static func UpdateCircleMultipliers(circleType : CircleType, upgrade : CircleUpgrade) -> void:
	if(upgrade.damage_type >= 0):
		damage_type_multipliers[circleType][upgrade.damage_type] = upgrade.statMultiplier;
	if(upgrade.statup_type >= 0):
		player_stat_multipliers[circleType][upgrade.statup_type] = upgrade.statMultiplier;

static func GetRandomPositionInsideCircle() -> Vector2:
	var radius = GetCircleRadius();
	var radiusOffset = 0.9; #10% offset
	#Use sqrt here to weight the rnd closer to circle radius
	var rndRadius = sqrt(randf()) * radius * radiusOffset;
	var rndAngle = randf_range(0, 2*PI);
	
	var rndPos = playerPos + Vector2(cos(rndAngle), sin(rndAngle)) * rndRadius;
	return rndPos;
	
static func GetRandomPositionOutsideCircle() -> Vector2:
	var radius = GetCircleRadius()
	var circle_radius = radius;
	
	var max_attempts = 100
	var attempt = 0
		
	var gameViewYMin = -GlobalVariables.screen_size/2;
	var gameViewYMax = GlobalVariables.screen_size/2;
	var gameViewXMin = -GlobalVariables.screen_size/2;
	var gameViewXMax = GlobalVariables.screen_size/2;
	
	while attempt < max_attempts:
		var rnd_pos = Vector2(randf_range(gameViewXMin, gameViewXMax), randf_range(gameViewYMin, gameViewYMax))
		if rnd_pos.distance_to(playerPos) > circle_radius:
			return rnd_pos
		attempt += 1
	
	# Fallback if no suitable point found
	return Vector2(gameViewXMax, gameViewYMax)

static func GetCircleRadius() -> float:
	return circleSprite.get_width() * CircleSelf.scale.x / 2.0;

static func IsPositionWithinInnerCircle(pos : Vector2) -> CircleType:
	var distFromPlayer = pos.distance_to(playerPos);
	if distFromPlayer <= GetCircleRadius():
		return CircleType.INNER;
	else:
		return CircleType.OUTER;
