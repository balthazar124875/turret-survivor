extends Control

class_name LootBoxRoller

@onready var item_row = $SubViewportContainer/SubViewport/ItemRow
@export var item_textures: Array[Texture2D]
@export var upgrades: Array[Upgrade]

@export var upgrade_element: PackedScene

const ITEM_WIDTH = 32
const ITEM_HEIGHT = 32
const VISIBLE_COUNT = 16

var speed_base = 1008
var speed = 1008
var rolling = false

var target_index = 7
var stop_requested = false
var callback: Callable

func _ready():
	pass
	
func request_stop_on(index: int):
	target_index = index
	stop_requested = true
	
func _process(delta):
	if rolling:
		for icon in item_row.get_children():
			icon.position.x -= speed * delta

			if icon.position.x + ITEM_WIDTH + 3 < -50:
				icon.position.x = _get_max_icon_x() + ITEM_WIDTH + 3
			
		if stop_requested:
			speed = clamp(speed - delta * 350.0, 0, speed_base)  # Gradual slowdown
		if stop_requested and speed <= 60.0:
			_final_align()
			
func _final_align():
	rolling = false
	stop_requested = false

	var center_x = $SubViewportContainer.size.x / 2
	var target_item = item_row.get_child(target_index)

	var item_offset = target_item.global_position.x - center_x + (target_item.size.x/2)

	# Animate a small correction using Tween
	var tween = get_tree().create_tween()
	tween.tween_property(item_row, "position:x", item_row.position.x - item_offset, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(1.5).timeout
	visible = false
	item_row.set_position(Vector2(0, 0))
	callback.call()
	
	
func populate_items():
	item_row.position = Vector2.ZERO
	for i in range(VISIBLE_COUNT):
		var item = upgrade_element.instantiate()
		var upgrade = upgrades[i]
		item.texture = upgrade.icon
		item.size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		item.position = Vector2(i * (ITEM_WIDTH + 3), 0)
		item.get_node("Rarity-Outline").modulate = get_color(upgrade.rarity)
		item_row.add_child(item)

func _get_max_icon_x() -> float:
	var max_x = -INF
	for icon in item_row.get_children():
		max_x = max(max_x, icon.position.x)
	return max_x

func populate_upgrades(upgrades : Array[Upgrade], callable: Callable) -> void:
	speed = speed_base
	for child in item_row.get_children():
		child.queue_free()
	self.upgrades = upgrades
	populate_items()
	visible = true
	rolling = true
	self.callback = callable
	
	await get_tree().create_timer(2.0).timeout
	request_stop_on(upgrades.size() - 1)
	

func get_color(rarity: Upgrade.UpgradeRarity) -> Color:
	match rarity:
		Upgrade.UpgradeRarity.COMMON: return Color(0.33, 0.33, 0.33)
		Upgrade.UpgradeRarity.UNCOMMON:	return Color(0, 0.75, 0)
		Upgrade.UpgradeRarity.RARE:	return Color(0, 0, 1)
		Upgrade.UpgradeRarity.LEGENDARY: return Color(1, 0.5, 0.25)
		Upgrade.UpgradeRarity.MYTHIC: return Color(1, 0, 0)
	return Color(1, 1, 1)
