#This class handles Achievements, Unlocks, general Progress
extends Node

#@onready var GameManager : GameManager = get_node("/root/EmilScene")
var achievementUI : PackedScene;

var unlock_list : Array[UnlockNode]; #Will hold all our Achievements and Unlocks
var lockedItemsDictionary : Dictionary = {};
var stakesCleared : Array[int]; #size = GameManager.TOTAL_PLAYER_COUNT
var challengesUnlocked : Array[bool]; #size = TOTAL_CHALLENGES_COUNT
var challengesCleared : Array[bool]; #size = TOTAL_CHALLENGES_COUNT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	achievementUI = load("res://Scenes/Main Menu/AchievementUI.tscn");
	#1. Läs in alla unlocks från fil in hit.
	#2. Executa deras function signalbus
	load_unlocks();
	for unlock in unlock_list:
		unlock.Init();
		
	pass # Replace with function body.

func load_unlocks() -> void:
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
			#var itemName = item.instantiate().name;
			var itemName = item.resource_path.get_file().get_basename();
			lockedItemsDictionary[itemName] = false;

func RenderAchievementBox(unlockName : String, unlockCondition : String, icon : Texture2D):
	var uiBox = achievementUI.instantiate();
	get_tree().root.add_child(uiBox);
	uiBox.get_node("SpellName").text = "New Character Unlocked!";
	uiBox.get_node("SpellDesc").text = unlockName + "\n" + unlockCondition;
	uiBox.get_node("Icon").texture = icon;
	var spawnPos = Vector2(0, -1080/2);
	uiBox.Init(spawnPos);
	pass
