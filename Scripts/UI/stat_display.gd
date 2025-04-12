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
		var text = "+ " + str(increase if !percentage else increase * 100) + ("%" if percentage else "")
		floating_text.display_text = text
		add_child(floating_text)
		$RichTextLabel.text = "[center]" + "+ " +str(((new_total - 1) * 100) if percentage else new_total) + ("%" if percentage else "") + "[/center]"
	pass
