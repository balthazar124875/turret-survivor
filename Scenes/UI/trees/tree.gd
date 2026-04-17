extends Control

class_name ItemTree

var growth_progress = 0
var growth_max = 10

var level: int = 1

var upgrade_cost: int = 50

var growth_bonus_chance = 0

@onready var fruit_1: Fruit = $Fruit1
@onready var fruit_2: Fruit = $Fruit2

@export var fruit1_start_level: int 
@export var fruit2_start_level: int 

@export var tag_bonuses: Dictionary[Upgrade.TAGS, float]

@export var growth_bonus: float = 1

@onready var player: Player = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(grow)
	$UpgradeButton.pressed.connect(try_upgrade)
	
	if(fruit1_start_level != 0):
		fruit_1.increase_growth(fruit1_start_level)
	if(fruit2_start_level != 0):
		fruit_2.increase_growth(fruit2_start_level)
	fruit_1.apply_tag_bonuses(tag_bonuses)
	fruit_2.apply_tag_bonuses(tag_bonuses)
	
	update_cost()

func update_cost():
	upgrade_cost = level * 50 + 50
	$UpgradeButton/Cost.text = "[center][img width=16 height=16]res://Assets/icons/dust.png[/img][color=cyan][font_size=12]" + String.num(upgrade_cost, 0) + "[/font_size][/color]"

func grow(wave: int):
	fruit_1.increase_growth()
	var r1 = randf()
	if(growth_bonus_chance > r1):
		fruit_1.increase_growth()
	
	fruit_2.increase_growth()
	var r2 = randf()
	if(growth_bonus_chance > r2):
		fruit_2.increase_growth()
	
func try_upgrade():
	if(player.dust >= upgrade_cost):
		player.modify_dust(-upgrade_cost)
		upgrade()
	
func upgrade():
	level += 1
	growth_bonus_chance += 0.2
	for v in tag_bonuses:
		tag_bonuses[v] *= 1.1
		fruit_1.apply_tag_bonuses(tag_bonuses)
		fruit_2.apply_tag_bonuses(tag_bonuses)
		
	$LevelText.text = "[center]Lv: [color=cyan] " + str(level)
	update_cost()
