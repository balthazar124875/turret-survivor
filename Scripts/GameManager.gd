#Game manager will initiate all spells/upgrades public,
#ready for use by the player and any other class
extends Node

class_name GameManager

var playerInitData;

func set_player_init_data(playerData : PlayerSelectNode) -> void:
	playerInitData = playerData;
	pass
