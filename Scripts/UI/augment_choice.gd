extends Panel

signal choice_selected(data)

var choice_data  # stores the object associated with this panel

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_panel_clicked()

func _on_panel_clicked():
	emit_signal("choice_selected", choice_data)
