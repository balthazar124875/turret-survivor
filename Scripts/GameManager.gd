#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

class_name GameManager

var TOTAL_PLAYER_COUNT = 5; #Increment this when adding new players.
var TOTAL_CHALLENGES_COUNT = 10;
var playerInitData;
var currStakeID : int;

func set_player_init_data(playerData : PlayerSelectNode, currStakeID : int) -> void:
	playerInitData = playerData;
	self.currStakeID = currStakeID;
	#print("Current stake: " + str(currStakeID));
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			# Clear current scene
			#get_tree().root.queue_free()
			get_tree().change_scene_to_file("res://Scenes/Main Menu/Character Select Screen/character_select_screen.tscn")
