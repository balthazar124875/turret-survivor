extends Panel

var augments: Array[AugmentUpgrade] = []
@onready var tooltipMgr : TooltipManager = $"../../../../../Tooltip"

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
	var texture = TextureRect.new()
	
	texture.texture = augment.icon
	texture.scale = Vector2(1.5, 1.5)
	texture.position = Vector2(6, 6)
	texture.mouse_filter = Control.MOUSE_FILTER_PASS
	
	augment_box.add_child(texture)
	
	
	augment_box.mouse_entered.connect(mouse_enter_augment.bind(augments.size()))
	augment_box.mouse_exited.connect(mouse_exit_augment)
	
	
	augments.push_back(augment)
	
	var style_box = augment_box.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	if style_box:
		style_box.border_color = color_selected

		augment_box.add_theme_stylebox_override("panel", style_box)
		
func mouse_enter_augment(index: int):
	tooltipMgr.DisplayTooltip(augments[index].get_tooltip(), get_child(index));
	pass
	
func mouse_exit_augment():
	tooltipMgr.HideTooltip();
