class_name Hit

@export var amount: float
@export var bonus_damage: float
@export var type: GlobalEnums.DAMAGE_TYPES
@export var on_hit_effects: Array[StatusEffect]
@export var after_hit_effects: Array[Callable] = []
@export var source: String

func _init(amount: float, type: GlobalEnums.DAMAGE_TYPES, on_hit_effects: Array[StatusEffect], source: String):
	self.amount = amount
	self.type = type
	self.on_hit_effects = on_hit_effects as Array[StatusEffect]
	self.source = source
