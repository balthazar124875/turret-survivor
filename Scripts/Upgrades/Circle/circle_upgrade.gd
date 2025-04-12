extends Upgrade

class_name CircleUpgrade

var iconBackgroundSprite : AnimatedSprite2D; #The Blue Or Red BackGround image we have on the spell icon
var circleUpgradeType : Circle.CircleType; #This should be random generated
@export var stickerTexture : Texture2D #The sticker that will be placed
var innerOuterString : String;
var stickerSpriteInstance : Sprite2D;

func _ready() -> void:
	pass
	
func _instantiate() -> void:
	stickerSpriteInstance = Sprite2D.new();
	stickerSpriteInstance.texture = stickerTexture;
	type = UpgradeType.CIRCLE
	var my_random_number = randi() % 2; # This will be either INNER or OUTER
	circleUpgradeType = my_random_number;
	if circleUpgradeType == Circle.CircleType.INNER:
		innerOuterString = "[color=blue]Inner[/color]";
	else:
		innerOuterString = "[color=red]Outer[/color]";
	UpgradeDescription()
	pass # Replace with function body.

func UpgradeDescription() -> void:
	pass

func applyUpgradeToPlayer(player: Player) -> void:
	if(upgradeAmount == 1):
		player.get_node("./Circle").add_child(stickerSpriteInstance);
		Circle.AddCircleUpgrade(circleUpgradeType, self);
		PlaceCircleUpgradeIcon(circleUpgradeType);
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
	player.get_node("./Circle/Upgrades").add_child(self)
	
func apply_level_up():
	pass
