extends Control

var debug_open = false
var loaded = false
var single_pick = true

@export var debug_button: PackedScene

@onready var player: Player = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_TAB:
			if debug_open: 
				close() 
			else: 
				open()
				
		if event.keycode == KEY_U:
			debug_get_all()

func open(single_pick: bool = false) -> void:
	debug_open = true
	visible = debug_open
	if(!loaded && debug_open):
		load_upgrades()
	self.single_pick = single_pick
	
	get_tree().paused = true
		
func close(single_pick: bool = false) -> void:
	debug_open = false
	visible = false
	if(!loaded && debug_open):
		load_upgrades()
		
	get_tree().paused = false
		

func debug_get_all():
	if(!loaded):
		load_upgrades()
		
	for button in get_node("BoxContainer").get_children():
		button.upgrade.applyPlayerUpgrade(player)

func load_upgrades() -> void:
			#Iterate all Upgrade scripts and put them in the global array
	var folders = ["Circle", "Stats", "Weapons", "Passives", "Augments", "Other"]
	for f in folders:
		var dir = DirAccess.open("res://Scenes/Upgrades/" + f);
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				var upgrade = load("res://Scenes/Upgrades/" + f  + "/" + file_name).instantiate()
				
				var upgrade_button = debug_button.instantiate()
				upgrade_button.init(upgrade)
				upgrade_button.pressed.connect(Callable(self, "_on_button_pressed").bind(upgrade_button.upgrade))
				
				get_node("BoxContainer").add_child(upgrade_button)
				
				file_name = dir.get_next()
				
				if(f == "Circle"):
					upgrade.stickerInit(); #Generate random inner outer functionality for circle upgrade
		else:
			print("An error occurred when trying to access the path.");
	loaded = true

func _on_button_pressed(upgrade: Upgrade):
	upgrade.applyPlayerUpgrade(player)
	if(single_pick):
		close()
		
