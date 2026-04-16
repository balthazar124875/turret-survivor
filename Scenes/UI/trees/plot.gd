extends Panel

class_name Plot

@export var unlocked: bool = false
var price: int

@onready var player: Player = get_node("/root/EmilScene/Player")

@export var tree_prefab : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!unlocked):
		SignalBus.plot_price_updated.connect(update_cost)
		$BuyButton.pressed.connect(buy)
	pass

func setup():
	if(unlocked == true):
		activate()

func update_cost(cost: int):
	price = cost
	$BuyButton/Cost.text = "[center][img width=16 height=16]res://Assets/icons/dust.png[/img][font_size=12][color=yellow]" + str(cost) + "[/color][/font_size]"

func buy():
	if(player.dust > price):
		player.modify_dust(-price)
		activate()

func activate():
	unlocked = true
	$BuyButton.queue_free()
	SignalBus.plot_bought.emit()
	SignalBus.plot_price_updated.disconnect(update_cost)
	plant_tree()

func plant_tree():
	#have more different trees to plant here
	
	var new_tree = tree_prefab.instantiate()
	$TextureRect.add_child(new_tree)
	new_tree.position = Vector2(-48, -84)
