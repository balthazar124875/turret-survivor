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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/EmilScene/Player");
	CircleSelf = self;
	playerPos = player.global_position;
	UpdateCircleSprite();
	circleUpgrades.append([]) #Inner
	circleUpgrades.append([]) #Outer
	pass # Replace with function body.

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
	
static func AddCircleUpgrade(circle : CircleType, upgrade : CircleUpgrade) -> void:
	circleUpgrades[circle].push_back(upgrade);
	
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
		
	var gameViewYMin = 0;
	var gameViewYMax = 1080;
	var gameViewXMin = 420;
	var gameViewXMax = 1500;
	
	while attempt < max_attempts:
		var rnd_pos = Vector2(randf_range(gameViewXMin, gameViewXMax), randf_range(gameViewYMin, gameViewYMax))
		if rnd_pos.distance_to(playerPos) > circle_radius:
			return rnd_pos
		attempt += 1
	
	# Fallback if no suitable point found
	return Vector2(gameViewXMax, gameViewYMax)

static func GetCircleRadius() -> float:
	return circleSprite.get_width() * CircleSelf.scale.x / 2.0;
	
func IsPositionWithinInnerCircle(pos : Vector2) -> bool:
	var distFromPlayer = pos.distance_to(player.global_position);
	return distFromPlayer <= GetCircleRadius();
