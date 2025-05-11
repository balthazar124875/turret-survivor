extends PassiveUpgrade

@export var health_restore = 0.2
@export var health_threshold = 0.25 #10%

var active = false

var damage_increase = false

var total_restored = 0

func applyUpgradeToPlayer(player: Player) -> void:
	if(!active):
		SignalBus.damage_done.connect(paralyze)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func paralyze(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, source: String, direct: bool):
	if(direct && (player.health/player.maxHealth) < health_threshold):
		player.heal_damage(health_restore, "Lifesteal")
		total_restored += health_restore
			
func apply_level_up():
	if(upgradeAmount == 10):
		damage_increase = true
		return
	
	match upgradeAmount % 2:
		0:
			health_restore += 0.2
		1:
			health_threshold += 0.01

func get_description() -> String:
	var text = "When below [color=red]" + str(health_threshold * 100) + "%[/color] max health direct hits to enemies restore [color=red]" + str(health_restore) + "[/color]" + IconHandler.get_icon_path("health") + "health"
	if(damage_increase):
		text += "\nLvl [color=yellow]10[/color]: Gives a damage boost for a short while after stealing health from enemies[color=red](Not implemented)"
	text += "\n[b]Total restored: [/b][color=red]" + str(total_restored) + "[/color]" + IconHandler.get_icon_path("health")
	return text
