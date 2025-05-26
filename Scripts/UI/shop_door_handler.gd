extends Sprite2D


@onready var original_pos = global_position
@onready var closed_pos = global_position + Vector2(0, 200)
@onready var shop_door_mask = get_node("..")

func _ready() -> void: 
	SignalBus.animate_shop_upgrade_door.connect(close_door)

func close_door() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", shop_door_mask.global_position, 0.3).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(refresh_shop_upgrades)
	tween.tween_property(self, "global_position", original_pos, 0.4).set_trans(Tween.TRANS_ELASTIC)

func refresh_shop_upgrades():
	SignalBus.refresh_shop_upgrades.emit()
