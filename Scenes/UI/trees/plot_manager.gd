extends Control

class_name Plot_Manager

var plots_owned: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.plot_bought.connect(add_plot)
	SignalBus.plot_price_updated.emit(get_next_plot_cost())
	
	for child in get_children():
		if child.has_method("setup"):
			child.setup()
	
func add_plot():
	plots_owned += 1
		
	SignalBus.plot_price_updated.emit(get_next_plot_cost())

func get_next_plot_cost():
	return 25 * plots_owned + 10 * pow(plots_owned, 2) + 10
