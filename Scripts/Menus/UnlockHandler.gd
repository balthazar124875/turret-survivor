#This class handles Achievements, Unlocks, general Progress
extends Node

#@onready var GameManager : GameManager = get_node("/root/EmilScene")
var achievementUI : PackedScene;

var unlock_list : Array[UnlockNode]; #Will hold all our Achievements and Unlocks
var lockedItemsDictionary : Dictionary = {};
var stakesCleared : Array[int]; #size = GameManager.TOTAL_PLAYER_COUNT
var challengesUnlocked : Array[bool]; #size = TOTAL_CHALLENGES_COUNT
var challengesCleared : Array[bool]; #size = TOTAL_CHALLENGES_COUNT

const save_file_path = "user://turrent_survivor_save_game.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	achievementUI = load("res://Scenes/Main Menu/AchievementUI.tscn");
	#1. Läs in alla unlocks från fil in hit.
	#2. Executa deras function signalbus
	load_unlocks();
	for unlock in unlock_list:
		unlock.Init();
	pass # Replace with function body.

func RenderAchievementBox(unlockName : String, unlockCondition : String, icon : Texture2D, isAchievement : bool):
	var uiBox = achievementUI.instantiate();
	get_tree().root.add_child(uiBox);
	if isAchievement:
		uiBox.get_node("SpellName").text = "Achievement Get!";
	else:
		uiBox.get_node("SpellName").text = "New Character Unlocked!";
	uiBox.get_node("SpellDesc").text = unlockName + "\n" + unlockCondition;
	uiBox.get_node("Icon").texture = icon;
	var spawnPos = Vector2(0, -GlobalVariables.screen_size/2);
	uiBox.Init(spawnPos);
	pass

func _unhandled_input(event: InputEvent) -> void:
	if(event is not InputEventKey):
		return
	
	if event.is_pressed() and event.keycode == KEY_P:
		print_save_file()
	if event.is_pressed() and event.keycode == KEY_O:
		recreate_save_file()

func print_save_file() -> void:
	if not FileAccess.file_exists(save_file_path):
		print("No save file found at: ", save_file_path)
		return

	var file = FileAccess.open(save_file_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	print("\n===== SAVE FILE CONTENTS =====")
	if data == null:
		print("Invalid or corrupted save file.")
	else:
		for key in data.keys():
			print(key, ": ", data[key])
	print("==============================")
	print("\n=== IN MEMORY SAVE CONTENT ===")
	print("stakesCleared: ", stakesCleared)
	print("challengesUnlocked: ", challengesUnlocked)
	print("challengesCleared: ", challengesCleared)
	print("lockedItemsDictionary: ", lockedItemsDictionary)
	print("==============================")


func recreate_save_file() -> void:
	if FileAccess.file_exists(save_file_path):
		DirAccess.remove_absolute(save_file_path)
		print("Deleted old save file.")
	create_initial_save_file()

func load_unlocks() -> void:
	load_save_data()
	var dir = DirAccess.open("res://Scenes/UnlockNodes/");
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var unlock = load("res://Scenes/UnlockNodes/" + file_name).instantiate()
			unlock_list.push_back(unlock)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path in UnlockNodes.");
		
	for unlock in unlock_list:
		for item in unlock.lockedItems:
			var itemName = item.resource_path.get_file().get_basename();
			lockedItemsDictionary[itemName] = false;

func save_data():
	var save_data = {
		"stakesCleared": stakesCleared,
		"challengesUnlocked": challengesUnlocked,
		"challengesCleared": challengesCleared,
		"lockedItemsDictionary": lockedItemsDictionary
	}
	
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
	print("Game saved successfully!")
	
func load_save_data():
	# Check if save file exists
	if not FileAccess.file_exists(save_file_path):
		print("No save file found. Creating a new one...")
		create_initial_save_file()
		return

	# Load existing file
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data == null:
		print("Failed to parse save file. Creating new one.")
		create_initial_save_file()
		return

	stakesCleared.assign(data["stakesCleared"])
	challengesUnlocked.assign(data["challengesUnlocked"])
	challengesCleared.assign(data["challengesCleared"])
	lockedItemsDictionary = data.lockedItemsDictionary

	print("Save file loaded successfully!")

func create_initial_save_file() -> void:
	var initial_data = {
		"stakesCleared": [],
		"challengesUnlocked": [],
		"challengesCleared": [],
		"lockedItemsDictionary": {}
	}
	
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(initial_data, "\t"))
	file.close()
	
	print("New save file created at: ", save_file_path)
