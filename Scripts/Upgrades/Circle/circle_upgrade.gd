extends Upgrade

class_name CircleUpgrade

var iconBackgroundSprite : AnimatedSprite2D; #The Blue Or Red BackGround image we have on the spell icon
var circleUpgradeType : Circle.CircleType; #This should be random generated
@export var stickerTexture : Texture2D #The sticker that will be placed
var innerOuterString : String;
var stickerSpriteInstance : Sprite2D;

func _ready() -> void:
	stickerSpriteInstance = Sprite2D.new();
	stickerSpriteInstance.texture = stickerTexture;
	type = UpgradeType.CIRCLE
	var my_random_number = randi() % 2; # This will be either INNER or OUTER
	circleUpgradeType = my_random_number;
	
	if circleUpgradeType == Circle.CircleType.INNER:
		innerOuterString = "[color=blue]Inner[/color]";
	else:
		innerOuterString = "[color=red]Inner[/color]";
	
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	pass

func applyUpgradeToCircle() -> void:
	if(upgradeAmount == 1):
		get_node("/root/EmilScene/Circle").add_child(stickerSpriteInstance);
		Circle.AddCircleUpgrade(circleUpgradeType, self);
		PlaceCircleUpgradeIcon(circleUpgradeType);
	else:
		level_up_upgrade();

#Place the icon at random position
func PlaceCircleUpgradeIcon(circleUpgradeType : Circle.CircleType) -> void:
	var rndPos : Vector2 = Vector2(0.0, 0.0);
	if circleUpgradeType == Circle.CircleType.INNER:
		rndPos = Circle.GetRandomPositionWithinInnerCircle();
	stickerSpriteInstance.global_position = rndPos;
	pass

func reparentToCircle() -> void:
	get_node("/root/EmilScene/Circle/Upgrades").add_child(self)
	
func level_up_upgrade():
	pass
