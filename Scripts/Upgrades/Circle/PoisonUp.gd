extends CircleUpgrade
	
func stickerInit() -> void:
	super();
	damage_type = GlobalEnums.DAMAGE_TYPES.POISON;
	statMultiplier = 1.1;
	
func UpgradeDescription() -> void:
	description = str("Increase all Poison damage in ", innerOuterString, " circle.");
	
func apply_level_up():
	statMultiplier += 0.1;
	Circle.UpdateCircleMultipliers(circleUpgradeType, self);
	pass
