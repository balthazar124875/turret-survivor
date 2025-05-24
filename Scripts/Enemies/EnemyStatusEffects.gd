extends Resource
class_name EnemyStatusEffect

@export var type: GlobalEnums.ENEMY_STATUS_EFFECTS
@export var duration: float
@export var magnitude: float
@export var source: String

func _init(type: GlobalEnums.ENEMY_STATUS_EFFECTS, duration: float, magnitude: float):
	self.type = type
	self.duration = duration
	self.magnitude = magnitude
