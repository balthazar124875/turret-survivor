extends Node

#All our control elements will have a onmouse enter etc.
#They will set ToolTipManager to visible when mouse is entered,
#and set the text on this, which it will render and display

class_name TooltipManager

@onready var panelContainer = $PanelContainer;
@onready var label = $PanelContainer/MarginContainer/RichTextLabel;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panelContainer.visible = false;
	pass # Replace with function body.

func DisplayTooltip(tooltipText : String, button : Control) -> void:
	label.text = tooltipText;
	panelContainer.visible = true;
	panelContainer.reset_size();
	#panelContainer.global_position = get_viewport().get_mouse_position();
	
	#Place the container at bottom centre of button
	var buttonSize = button.get_global_rect().size;
	buttonSize.x *= 0.5; #Place it at centre on x-axis only
	panelContainer.global_position = button.global_position + buttonSize;
	if(button.global_position.x > 0):
		panelContainer.global_position += Vector2(-250, 0) #fix this sometime
		if(button.global_position.y > 250):
			panelContainer.global_position += Vector2(-150, -200) #fix this sometime
	pass;
	
func HideTooltip() -> void:
	label.text = "";
	panelContainer.visible = false;
	panelContainer.reset_size();
	pass;

func _process(delta: float) -> void:
	#Update position
	#panelContainer.global_position = get_viewport().get_mouse_position();
	pass
