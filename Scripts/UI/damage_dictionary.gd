extends Control

var damages = {}
var heals = {}
var start_y = 10

@onready var total_damage_label = get_node("./Damage/DamageDone")
@onready var total_heal_label = get_node("./Heal/HealDone")
@onready var damage_list = get_node("./Damage/DamageList")
@onready var heal_list = get_node("./Heal/HealList")

var total_damage = 0
var total_heal = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.damage_done.connect(_add_damage)
	SignalBus.heal_done.connect(_add_heal)
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
		var label = get_damage_child_by_name(source)
		damages[source] += amount
		label.text = source + ": " + str(round(damages[source]))
	else:
		var label = Label.new()
		damage_list.add_child(label)
		label.position = Vector2(0, get_child_count() * 40)
		label.name =  source
	
		damages[source] = amount
		label.text = source + ": " + str(round(damages[source]))
	total_damage += amount
	total_damage_label.text = str("Damage done: ", round(total_damage))

func _add_heal(amount: float, source: String):
	if (source == ''):
		return
	if source in heals:
		var label = get_heal_child_by_name(source)
		heals[source] += amount
		label.text = source + ": " + str(round(heals[source]))
	else:
		var label = Label.new()
		heal_list.add_child(label)
		label.position = Vector2(0, get_child_count() * 40)
		label.name = source
	
		heals[source] = amount
		label.text = source + ": " + str(round(heals[source]))
	total_heal += amount
	total_heal_label.text = str("Heal done: ", round(total_heal))
	
func _print():
	for key in damages.keys():
		var value = damages[key]
		print(key, ":", value)

func get_damage_child_by_name(child_name: String) -> Node:
	# Loop through all child nodes
	for child in damage_list.get_children():
		if child.name == child_name:
			return child  # Return the child node if it matches the name
	
	# Return null if no child with that name is found
	return null

func get_heal_child_by_name(child_name: String) -> Node:
	# Loop through all child nodes
	for child in heal_list.get_children():
		if child.name == child_name:
			return child  # Return the child node if it matches the name
	
	# Return null if no child with that name is found
	return null
