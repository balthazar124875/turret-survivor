extends CircleUpgrade
	
func _instantiate() -> void:
	super();
	stickerSpriteInstance.scale *= 0.5;
	damage_type = GlobalEnums.DAMAGE_TYPES.ICE;
	statMultiplier = 1.1;
	
func UpgradeDescription() -> void:
	description = str("Increase all Ice damage in ", innerOuterString, " circle.");
	
func apply_level_up():
	statMultiplier += 0.1;
	Circle.UpdateCircleMultipliers(circleUpgradeType, self);
	pass
