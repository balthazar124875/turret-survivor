extends PassiveUpgrade

@export var procChance = 0.05
@export var luckScaling = 0.05
@export var number_of_projectiles = 1
@export var damage = 5

@export var projectile_scene: PackedScene
@export var source: String


func reparentToPlayer(player: Player) -> void:
	super.reparentToPlayer(player)
	SignalBus.damage_done.connect(aracane_missile_proc_check)

func aracane_missile_proc_check(enemy: Enemy, amount: float, damageType: GlobalEnums.DAMAGE_TYPES, damage_source: String, direct: bool):
	if(damageType == GlobalEnums.DAMAGE_TYPES.MAGIC && damage_source != source):
		var total_proc = procChance * (1 + (player.luck * luckScaling))
		while total_proc > 1:
			create_arcane_missile()
			total_proc -= 1
		
		var rndNumber = randf_range(0.0, 1.0);
		if(rndNumber <= total_proc):
			#print(procChance * (1 + (player.luck * luckScaling)))
			#print("procChance: ", procChance)
			#print("player.luck: ", player.luck)
			#print("luckScaling: " , luckScaling)

			create_arcane_missile()

func create_arcane_missile():
	for i in range(number_of_projectiles):
		var new_arcane_missile = projectile_scene.instantiate()
		new_arcane_missile.apply_force(Vector2(randf_range(-2000,2000),-4000))
		new_arcane_missile.damage_type = GlobalEnums.DAMAGE_TYPES.MAGIC
		new_arcane_missile.damage = 5
		new_arcane_missile.source = source
		get_node("/root").add_child(new_arcane_missile)
		new_arcane_missile.global_position = player.global_position

func get_description() -> String:
	return "Magic damage has a [color=red]" + str(100 * (procChance * (1 + (player.luck * luckScaling)))) + "%[/color](" + str(procChance * 100) + "+" + str(procChance * luckScaling * 100) + "*" + IconHandler.get_icon_path("luck") + ") to fire a arcane missile dealing [color=red]" + str(damage) + "[/color] damage"

func apply_level_up():
	if(upgradeAmount == 5):
		damage += 3
		return
	
	if(upgradeAmount == 10):
		procChance += 0.5
		return
	
	match upgradeAmount % 2:
		0:
			procChance += 0.05
		1:
			damage += 1
