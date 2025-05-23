extends Control

@export var stat: GlobalEnums.PLAYER_STATS
@export var percentage: bool

var floating_text = preload("res://Scenes/UI/floating_text.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.stat_updated.connect(_update_stat)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_stat(stat: GlobalEnums.PLAYER_STATS, new_total: float, increase: float) -> void:
	if(stat == self.stat):
		var floating_text = floating_text.instantiate()
		var text = ("+" if increase > 0 else "") + str(increase if !percentage else increase * 100) + ("%" if percentage else "")
		floating_text.display_text = text
		floating_text.color = ("yellow" if increase > 0 else "red")
		add_child(floating_text)
		$RichTextLabel.text = "[center]" + ("+" if increase > 0 else "") +String.num((((new_total - 1) * 100) if percentage else new_total), 2) + ("%" if percentage else "") + "[/center]"
	pass
