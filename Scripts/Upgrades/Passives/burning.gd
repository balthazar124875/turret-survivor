extends PassiveUpgrade

@export var burnAmount = 0.5 #10%
@export var duration = 2 #10%

@export var procChance = 0.1
@export var luckScaling = 0.05

var active = false

var burn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.before_enemy_take_hit.connect(_before_hit)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _before_hit(amount: float, type: GlobalEnums.DAMAGE_TYPES, on_hit_effects: Array):
	if(type == GlobalEnums.DAMAGE_TYPES.FIRE):
		var rndNumber = randf_range(0.0, 1.0);
		if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
			#if(!on_hit_effects.any(func(e): return e.type == GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING)):
			var burnEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.BURNING, burnAmount * amount, duration)
			on_hit_effects.append(burnEffect)
				

func apply_level_up():
	if(upgradeAmount == 10):
		burn = true
		return
	
	match upgradeAmount % 2:
		0:
			burnAmount += 0.03
		1:
			procChance += 0.1

func get_description() -> String:
	var text = TooltipHelper.get_luck_scaling_format(procChance, luckScaling, player.luck) + " for Fire Damage to burn enemies for [color=red]" + str(100 * burnAmount) + "%[/color] of damage / 0.5s for [color=cyan]" + str(duration) + "[/color] seconds"
	if(burn):
		text += "\nLvl [color=yellow]10[/color]: does something"
	return text
