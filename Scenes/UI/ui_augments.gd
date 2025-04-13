extends Panel

var augments: Array[AugmentUpgrade] = []

@export var color_selected: Color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.augment_recieved.connect(new_augment)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_augment(augment: AugmentUpgrade):
	var augment_box = get_child(augments.size())
	var sprite = Sprite2D.new()
	sprite.texture = augment.icon
	sprite.scale = Vector2(1.5, 1.5)
	sprite.position = Vector2(30, 30)
	
	augment_box.add_child(sprite)
	augments.push_back(augment)
	
	var style_box = augment_box.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	if style_box:
		style_box.border_color = color_selected

		augment_box.add_theme_stylebox_override("panel", style_box)
