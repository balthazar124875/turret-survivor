extends PassiveUpgrade

@export var max_health_removed: float = 500
@export var income_gold_gain: float = 10

@onready var player = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func offerHealth() -> void:
	player.modify_income(income_gold_gain)
	player.modify_max_health(-500)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_level_up():
	weight *= 2
	print(weight)
	offerHealth()
