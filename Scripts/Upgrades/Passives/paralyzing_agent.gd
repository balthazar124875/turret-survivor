extends PassiveUpgrade

@export var duration = 0.4 #10%

@export var procChance = 0.1
@export var luckScaling = 0.05

var active = false

var damageIncrease = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.damage_done.connect(paralyze)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func paralyze(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(damageType == GlobalEnums.DAMAGE_TYPES.POISON):
		var rndNumber = randf_range(0.0, 1.0);
		if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
			var slow = EnemyStatusEffect.new()
			slow.type = GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED
			slow.duration = duration
			slow.magnitude = 1
			enemy.apply_status_effect(slow)
			
func apply_level_up():
	if(upgradeAmount == 10):
		damageIncrease = true
		return
	
	match upgradeAmount % 2:
		0:
			duration += 0.1
		1:
			procChance += 0.1

func get_description() -> String:
	var text = TooltipHelper.get_luck_scaling_format(procChance, luckScaling, player.luck) + " for poison damage to paralyze enemy for [color=green]" + str(duration) + "[/color] seconds"
	if(damageIncrease):
		text += "\nLvl [color=yellow]10[/color]: Paralyzed enemies take more damage[color=red](Not implemented)"
	return text
