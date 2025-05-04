extends AugmentUpgrade

@export var armor_reduction = 1

func _ready() -> void:
	SignalBus.damage_done.connect(reduce_armor)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reduce_armor(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(direct && damageType == GlobalEnums.DAMAGE_TYPES.FIRE):
		enemy.armor -= armor_reduction
