extends Control

var damages = {}
var start_y = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.damage_done.connect(_add_damage)
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Y:
			_print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_damage(amount: float, source: String):
	if (source == ''):
		return
	if source in damages:
		var label = get_child_by_name(source)
		damages[source] += amount
		label.text = source + ": " + str(round(damages[source]))
	else:
		var label = Label.new()
		add_child(label)
		label.position = Vector2(0, get_child_count() * 40)
		label.name = source
	
		damages[source] = amount
		label.text = source + ": " + str(round(damages[source]))
	
func _print():
	for key in damages.keys():
		var value = damages[key]
		print(key, ":", value)

func get_child_by_name(child_name: String) -> Node:
	# Loop through all child nodes
	for child in get_children():
		if child.name == child_name:
			return child  # Return the child node if it matches the name
	
	# Return null if no child with that name is found
	return null
