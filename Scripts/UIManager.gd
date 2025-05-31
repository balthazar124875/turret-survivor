#Apply this script to the root UI element

extends Node

class_name UIManager;

var kills: float

@onready var player: Player = get_node("/root/EmilScene/Player")

@onready var progress_bar: TextureProgressBar = get_node("LeftMenuColumn/RerollContainer/Gold/TextureProgressBar") 
@onready var tooltipMgr : TooltipManager = get_node("Tooltip")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	subscribe_to_signals()

func _process(delta):
	if player.income_timer.time_left > 0:
		progress_bar.value = progress_bar.max_value - player.income_timer.time_left
	else:
		progress_bar.value = 0
		
func subscribe_to_signals() -> void:
	SignalBus.gold_amount_updated.connect(on_gold_or_income_updated)
	SignalBus.current_wave_updated.connect(on_wave_updated)
	SignalBus.enemy_killed.connect(on_enemy_killed)
	on_gold_or_income_updated()
	SignalBus.stat_updated.connect(update_progress_bar)
	SignalBus.stat_updated.connect(update_income)
	setup_income_timer_ui()
	
	get_node("LeftMenuColumn/RerollContainer/Gold/Amount").mouse_entered.connect(mouse_income_enter_augment.bind())
	get_node("LeftMenuColumn/RerollContainer/Gold/Amount").mouse_exited.connect(mouse_exit_income.bind())

func update_progress_bar(stat: GlobalEnums.PLAYER_STATS, new_total: float, increase: float) -> void:
	if(stat == GlobalEnums.PLAYER_STATS.MULTIPLY_INCOME_TIMER):
		setup_income_timer_ui()
		
func setup_income_timer_ui():
	progress_bar.max_value = player.income_timer.wait_time
	#progress_bar.value = player.income_timer.wait_time

func on_wave_updated(current_wave: int) -> void:
	get_node("LeftMenuColumn/WaveLabel").text = "Wave: " + str(current_wave)
	
func update_income(stat: GlobalEnums.PLAYER_STATS, new_total: float, increase: float) -> void:
	if(stat == GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME):
		on_gold_or_income_updated()
		
func on_gold_or_income_updated() -> void:
	get_node("LeftMenuColumn/RerollContainer/Gold/Amount").text = IconHandler.get_icon_path("coin") + "[color=black]" + str(player.gold) + "(+" + str(player.get_interest() + player.gold_income) + ")"
	
func on_enemy_killed(_e) -> void:
	kills += 1
	get_node("RightMenuColumn/TabContainer/Stats/KillsLabel").text = "Kills: " + str(kills)
	
func mouse_income_enter_augment():
	tooltipMgr.DisplayTooltip(get_income_tooltip_text(), get_node("LeftMenuColumn/RerollContainer/Gold/Amount"));
	pass

func get_income_tooltip_text() -> String:
	var text = "Gold: " + str(player.gold) + IconHandler.get_icon_path("coin")
	text += "\nIncome: " + str(player.get_interest() + player.gold_income) + IconHandler.get_icon_path("coin")
	text += "\n -base: " + str(player.gold_income) + IconHandler.get_icon_path("coin")
	text += "\n -interest: " + str(player.get_interest()) + IconHandler.get_icon_path("coin") + " (1" + IconHandler.get_icon_path("coin") + "for each " + str(player.interest_per_amount) + IconHandler.get_icon_path("coin") + " up to " + str(player.interest_per_amount) + ")"
	return text
	
func mouse_exit_income():
	tooltipMgr.HideTooltip();
