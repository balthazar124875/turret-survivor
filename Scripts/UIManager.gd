#Apply this script to the root UI element

extends Node

class_name UIManager;

var kills: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	subscribe_to_signals()

func subscribe_to_signals() -> void:
	SignalBus.gold_amount_updated.connect(on_gold_updated)
	SignalBus.current_wave_updated.connect(on_wave_updated)
	SignalBus.enemy_killed.connect(on_enemy_killed)
	on_gold_updated(get_node("/root/EmilScene/Player").gold)

func on_wave_updated(current_wave: int) -> void:
	get_node("LeftMenuColumn/WaveLabel").text = "Wave: " + str(current_wave)
	
func on_gold_updated(gold: int) -> void:
	get_node("LeftMenuColumn/GoldLabel").text = "Gold: $" + str(gold)
	
func on_enemy_killed(_e) -> void:
	kills += 1
	get_node("RightMenuColumn/KillsLabel").text = "Kills: " + str(kills)
	
