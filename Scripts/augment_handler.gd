extends Control

@onready var player = get_node("/root/EmilScene/Player")
@onready var gameManager : GameManager = get_node("/root/EmilScene")

@export var augment_button: PackedScene

@export var augment_scenes: Array[PackedScene] = []
var augment_list: Array[AugmentUpgrade] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_wave_updated.connect(check_wave)
	load_augments()
	pass # Replace with function body.

func load_augments() -> void:
	for scene in augment_scenes:
		if(gameManager.playerInitData.startAugments.has(scene)):
			continue
			
		var augment = scene.instantiate()
		
		augment_list.push_back(augment)
		#var augment_file_name = scene.get_basename()
		#var augment_is_locked = augment.isLocked && UnlockHandler.lockedItemsDictionary.get(augment_file_name, false) == false
			#
		#if augment_is_locked:
			#pass
		#else: 
			#augment_list.push_back(augment)
			
	#var dir = DirAccess.open("res://Scenes/Upgrades/Augments");
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#var resource = load("res://Scenes/Upgrades/Augments/" + file_name)
			#var augment = resource.instantiate()
		#
			## Used for checking if it is locked / unlocked
			#var augment_file_name = resource.resource_path.get_file().get_basename()
			#
			## If augment is set to false in unlocks handler, do not add to available augment list
			#var augment_is_locked = augment.isLocked && UnlockHandler.lockedItemsDictionary.get(augment_file_name, false) == false
			#
			#if augment_is_locked:
				#pass
			#else: 
				#augment_list.push_back(augment)
			#file_name = dir.get_next()
	#else:
		#print("An error occurred when trying to access the path.");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_wave(wave: int):
	if(wave == 10 || wave == 30 || wave == 55 || wave == 80):
		get_tree().paused = true
		get_node("ColorRect").visible = true
		spawn_augments()

func spawn_augments():
	augment_list.shuffle()  # Randomize the order
	var augments = augment_list.slice(0, 3)  # Take the first 3 items
	for i in augments.size():
		var augment = augments[i]
		var new_augment = augment_button.instantiate()
		new_augment.get_node("Name").text = "[center][b][color=3f3f74]" + augment.upgradeName
		new_augment.get_node("Description").text = "[center][color=3f3f74]" + augment.description
		new_augment.get_node("Icon").texture = augment.icon
		new_augment.name = "augment" + str(i)
		add_child(new_augment)
		new_augment.position = Vector2(630 + i * 230, 420)
		new_augment.choice_data = augment
		new_augment.connect("choice_selected", Callable(self, "_on_choice_selected"))
		augment_list.erase(augments[i])
		
func _on_choice_selected(choice: AugmentUpgrade):
	SignalBus.augment_recieved.emit(choice)
	reset()
	choice.applyUpgradeToPlayer(player)
	print(choice.upgradeName)

func reset():
	for child in get_children():
		if "augment" in child.name:
			remove_child(child)
			child.queue_free()
	get_tree().paused = false
	get_node("ColorRect").visible = false
