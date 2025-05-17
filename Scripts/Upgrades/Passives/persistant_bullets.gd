extends PassiveUpgrade

@export var extraDuration = 0.5

@export var procChance = 0.15
@export var luckScaling = 0.05

@export var damageBonus = 1.05

var active = false

var magicDamage = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.bullet_created.connect(_bullet_created)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _bullet_created(bullet):
	bullet.effects.append(_apply_effects)
			
func _apply_effects(enemy: Enemy, bullet):
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		bullet.life_time += extraDuration
		if(magicDamage):
			#make bullets do magic damage
			
			bullet.scale += Vector2(damageBonus -1, damageBonus - 1)
			bullet.damage *= damageBonus

func apply_level_up():
	if(upgradeAmount == 10):
		magicDamage = true
		return
	
	match upgradeAmount % 2:
		0:
			extraDuration += 0.1
		1:
			procChance += 0.05

func get_description() -> String:
	var text = TooltipHelper.get_luck_scaling_format(procChance, luckScaling, player.luck) + " to increase bullet lifetime by [color=yellow]" + str(extraDuration) + "[/color] seconds when they hit enemies"
	if(magicDamage):
		text += "\nLvl [color=yellow]10[/color]: Also increases the bullets damage and size by [color=red]" + str((damageBonus - 1) * 100) + "[/color]%"
	return text
