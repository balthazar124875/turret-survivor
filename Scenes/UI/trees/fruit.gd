extends Control

class_name Fruit

enum GROWTH_STAGE {
	NONE,
	START,
	COMMON,
	RARE,
	LEGENDARY,
	MYTHIC
}

@export var stage_0: Texture2D = load("res://Assets/schizo-paints/fruit_0.png")
@export var stage_1: Texture2D = load("res://Assets/schizo-paints/fruit_1.png")
@export var stage_2: Texture2D = load("res://Assets/schizo-paints/fruit_2.png")
@export var stage_3: Texture2D = load("res://Assets/schizo-paints/fruit_3.png")
@export var stage_mythic: Texture2D = load("res://Assets/schizo-paints/fruit_4.png")

var growth_stage: GROWTH_STAGE = GROWTH_STAGE.START
var growth_step = 0

@onready var upgrade_handler: UpgradeHandler = get_node("/root/EmilScene/GameplayUi/UpgradeHandler")

var tag_bonuses: Dictionary[Upgrade.TAGS, float]

@onready var mat: ShaderMaterial = $Image.material as ShaderMaterial

var outline_strength := 0.0
var hover := false
const SPEED := 4.0

func _process(delta):
	var target := 1.0 if hover else 0.0
	outline_strength = lerp(outline_strength, target, delta * SPEED)
	mat.set_shader_parameter("outline_strength", outline_strength)


func _ready():
	$Image.pressed.connect(harvest)
	$Image.mouse_entered. connect(_on_mouse_entered)
	$Image.mouse_exited. connect(_on_mouse_exited)
	
	mat = $Image.material.duplicate()
	$Image.material = mat
	mat.set_shader_parameter("outline_strength", outline_strength)
	pass

func apply_tag_bonuses(tag_bonuses):
	self.tag_bonuses = tag_bonuses

func increase_growth(amount = 1):
	growth_step += amount
	if(growth_step >= 10):
		growth_step = 10
	update_growth_state()
	
func update_growth_state():
	if(growth_step > 9):
		$Image.texture_normal = stage_3
		growth_stage =GROWTH_STAGE.LEGENDARY
	elif (growth_step > 5):
		$Image.texture_normal = stage_2
		growth_stage = GROWTH_STAGE.RARE
	elif (growth_step > 2):
		$Image.texture_normal = stage_1
		growth_stage = GROWTH_STAGE.COMMON
	elif (growth_step > 0):
		$Image.texture_normal = stage_0
		growth_stage = GROWTH_STAGE.START
	else:
		$Image.texture_normal = null
		growth_stage = GROWTH_STAGE.NONE
		
	$Warning.visible = growth_step > 9	
	$Progress.texture = load("res://Assets/schizo-paints/growth_progress/growth_" + str(growth_step) + ".png")
	
func harvest():
	if(growth_stage == GROWTH_STAGE.START):
		return 
		
	var rarity = get_rarity()
	
	
	
	match rarity:
		
		Upgrade.UpgradeRarity.MYTHIC:
			upgrade_handler.roll_upgrades(3, rarity, tag_bonuses)
		Upgrade.UpgradeRarity.LEGENDARY:
			upgrade_handler.roll_upgrades(2, rarity, tag_bonuses)
		Upgrade.UpgradeRarity.RARE:
			upgrade_handler.roll_upgrades(3, rarity, tag_bonuses)
		Upgrade.UpgradeRarity.UNCOMMON:
			upgrade_handler.roll_upgrades(4, rarity, tag_bonuses)
		Upgrade.UpgradeRarity.COMMON:
			upgrade_handler.roll_upgrades(5, rarity, tag_bonuses)
	growth_stage = GROWTH_STAGE.NONE
	growth_step = 0
	
	update_growth_state()

func get_rarity() -> Upgrade.UpgradeRarity:
	var r = randf()
	match growth_stage:
		GROWTH_STAGE.COMMON:
			if(r > 0.9):
				return Upgrade.UpgradeRarity.RARE
			if(r > 0.6):
				return Upgrade.UpgradeRarity.UNCOMMON
				
			return Upgrade.UpgradeRarity.COMMON
		GROWTH_STAGE.RARE:
			if(r > 0.9):
				return Upgrade.UpgradeRarity.LEGENDARY
			if(r > 0.55):
				return Upgrade.UpgradeRarity.RARE
			if(r > 0.1):
				return Upgrade.UpgradeRarity.UNCOMMON
				
			return Upgrade.UpgradeRarity.COMMON
		GROWTH_STAGE.LEGENDARY:
			#if(r > 0.1):
				#return Upgrade.UpgradeRarity.MYTHIC
			if(r > 0.65):
				return Upgrade.UpgradeRarity.LEGENDARY
			if(r > 0.2):
				return Upgrade.UpgradeRarity.RARE
			return Upgrade.UpgradeRarity.UNCOMMON
		GROWTH_STAGE.MYTHIC:
			return Upgrade.UpgradeRarity.MYTHIC
	return Upgrade.UpgradeRarity.COMMON

func _on_mouse_entered():
	hover = growth_stage != GROWTH_STAGE.START

func _on_mouse_exited():
	hover = false
