extends CircleUpgrade
	
func _instantiate() -> void:
	super();
	damage_type = GlobalEnums.DAMAGE_TYPES.POISON;
	statMultiplier = 1.1;
	
func UpgradeDescription() -> void:
	description = str("Increase poison damage in ", innerOuterString, " circle.");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func apply_level_up():
	statMultiplier += 0.1;
	Circle.UpdateCircleMultipliers(circleUpgradeType, self);
	pass
