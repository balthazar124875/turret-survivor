extends PassiveUpgrade

@export var recycle_value = 10

var active = false

var trap_improvement = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.trap_expired.connect(recycle)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recycle(trap: Trap):
	player.modify_gold(recycle_value)
	if(trap_improvement):
		var trap_upgrade = player.get_random_weapon("trap")
		trap_upgrade.applyPlayerUpgrade(player)
			
func apply_level_up():
	if(upgradeAmount == 10):
		trap_improvement = true
		return
	
	recycle_value += 5

func get_description() -> String:
	var text = "Recieve [color=yellow]" + str(recycle_value) + "[/color]" + IconHandler.get_icon_path("coin") + " when a trap expires"
	if(trap_improvement):
		text += "\nLvl [color=yellow]10[/color]: Recycling a trap sometimes upgrades a trap weapon one stage"
	return text
