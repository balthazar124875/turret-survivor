extends Button

var upgrade: Upgrade
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(upgrade: Upgrade) -> void:
	icon = upgrade.icon
	#text = upgrade.upgradeName
	self.upgrade = upgrade
