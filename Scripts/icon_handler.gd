extends Node

func get_icon_path(icon_name: String, width: int = 16, height: int = 16) -> String:
	return "[img width=" + str(width) + " height=" + str(height) + "]res://Assets/icons/" + icon_name + ".png[/img]"
