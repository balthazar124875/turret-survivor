#Apply this script to the root UI element

extends Node

class_name UIManager;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	subscribe_to_signals()

func subscribe_to_signals() -> void:
	SignalBus.gold_amount_updated.connect(on_gold_updated)
	SignalBus.current_wave_updated.connect(on_wave_updated)

func on_wave_updated(current_wave: int) -> void:
	get_node("WaveLabel").text = "Wave: " + str(current_wave)
	
func on_gold_updated(gold: int) -> void:
	get_node("GoldLabel").text = "Gold: $" + str(gold)
	
