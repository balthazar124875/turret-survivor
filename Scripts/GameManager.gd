#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

class_name GameManager

var TOTAL_PLAYER_COUNT = 3; #Increment this when adding new players.
var TOTAL_CHALLENGES_COUNT = 10;
var playerInitData;
var currStakeID : int;

func set_player_init_data(playerData : PlayerSelectNode, currStakeID : int) -> void:
	playerInitData = playerData;
	self.currStakeID = currStakeID;
	#print("Current stake: " + str(currStakeID));
	pass
