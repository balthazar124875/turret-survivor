extends Upgrade

class_name CircleUpgrade

var circleUpgradeType : Circle.CircleType; #This should be random generated
@export var stickerTexture : Texture2D #The sticker that will be placed
@export var shopIconFilePath : String;
var innerOuterString : String;
var stickerSpriteInstance : Sprite2D;
var damage_type : GlobalEnums.DAMAGE_TYPES = -1;
var statup_type : GlobalEnums.PLAYER_STATS = -1;
var statMultiplier = 1.0;

func _ready() -> void:
	type = UpgradeType.CIRCLE
	pass
	
func stickerInit() -> void:
	stickerSpriteInstance = Sprite2D.new();
	stickerSpriteInstance.texture = stickerTexture;
	type = UpgradeType.CIRCLE
	var my_random_number = randi() % 2; # This will be either INNER or OUTER
	circleUpgradeType = my_random_number;
	if circleUpgradeType == Circle.CircleType.INNER:
		innerOuterString = "[color=DEEP_SKY_BLUE]Inner[/color]";
	else:
		innerOuterString = "[color=CRIMSON]Outer[/color]";
		
	# Create a new 32x32 white texture
	var sticker_image := Image.load_from_file(shopIconFilePath) #OG sticker image from the @export
	var backgroundImage := Image.load_from_file("res://Textures/Circle/blank_white.png");
	if circleUpgradeType == Circle.CircleType.INNER:
		backgroundImage.fill(Color.DODGER_BLUE)
	else:
		backgroundImage.fill(Color.CRIMSON)
	
	#Blit
	backgroundImage.blit_rect_mask(
		sticker_image,                       # source image
		sticker_image,                       # use sticker's alpha as mask
		Rect2i(Vector2i.ZERO, sticker_image.get_size()), # region to copy
		Vector2i.ZERO                        # position on background
	)
	
	#var texture := ImageTexture.create_from_image(image)
	var combined_texture := ImageTexture.create_from_image(backgroundImage)
	
	icon = combined_texture

	UpgradeDescription()
	
	# Load and apply the shader
	var shader = load("res://vfxShaders/enemy_outline.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	stickerSpriteInstance.material = shader_material
	stickerSpriteInstance.material.set_shader_parameter("outline_color", Vector4(1, 1, 1, 1))
	
	pass # Replace with function body.

func UpgradeDescription() -> void:
	pass

func applyUpgradeToPlayer(player: Player) -> void:
	if(upgradeAmount == 1):
		player.get_node("./Circle").add_child(stickerSpriteInstance);
		Circle.AddCircleUpgrade(circleUpgradeType, self);
		PlaceCircleUpgradeIcon(circleUpgradeType);
		reparentToPlayer(player)
	else:
		apply_level_up();

#Place the icon at random position
func PlaceCircleUpgradeIcon(circleUpgradeType : Circle.CircleType) -> void:
	var rndPos : Vector2 = Vector2(0.0, 0.0);
	if circleUpgradeType == Circle.CircleType.INNER:
		rndPos = Circle.GetRandomPositionInsideCircle();
	if circleUpgradeType == Circle.CircleType.OUTER:
		rndPos = Circle.GetRandomPositionOutsideCircle();
	stickerSpriteInstance.global_position = rndPos;
	pass
	
func reparentToPlayer(player: Player) -> void:
	player.playerUpgrades.push_back(self)
	player.get_node("./Circle/Upgrades").add_child(self)
	
func apply_level_up():
	statMultiplier += 0.1;
	Circle.UpdateCircleMultipliers(circleUpgradeType, self);
	pass
