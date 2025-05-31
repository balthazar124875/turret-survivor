
class_name Hit

@export var amount: float
@export var type: GlobalEnums.DAMAGE_TYPES
@export var on_hit_effects: Array[EnemyStatusEffect]
@export var after_hit_effects: Array[Callable] = []
@export var source: String

func _init(amount: float, type: GlobalEnums.DAMAGE_TYPES, on_hit_effects: Array[EnemyStatusEffect], source: String):
	self.amount = amount
	self.type = type
	self.on_hit_effects = on_hit_effects as Array[EnemyStatusEffect]
	self.source = source
