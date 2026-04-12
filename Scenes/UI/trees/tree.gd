extends Control

class_name ItemTree

var growth_progress = 0
var growth_max = 10

@onready var fruit_1: Fruit = $Fruit1
@onready var fruit_2: Fruit = $Fruit2

@export var fruit1_start_level: int 
@export var fruit2_start_level: int 

@export var tag_bonuses: Dictionary[Upgrade.TAGS, float]

@export var growth_bonus: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(grow)
	
	if(fruit1_start_level != 0):
		fruit_1.increase_growth(fruit1_start_level)
	if(fruit2_start_level != 0):
		fruit_2.increase_growth(fruit2_start_level)
	fruit_1.apply_tag_bonuses(tag_bonuses)
	fruit_2.apply_tag_bonuses(tag_bonuses)

func grow(wave: int):
	fruit_1.increase_growth()
	fruit_2.increase_growth()
	
