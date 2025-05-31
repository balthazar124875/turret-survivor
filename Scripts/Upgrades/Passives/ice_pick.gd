extends PassiveUpgrade

@export var damage_bonus = 0.2 #10%

var active = false
var unique_effect = false

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
	
func _before_hit(hit: Hit, enemy: Enemy):
	if enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN):
		var bonus_damage = 1 + (damage_bonus)
		hit.amount *= bonus_damage
		hit.after_hit_effects.append(remove_freezes)
	
				
func apply_level_up():
	if(upgradeAmount == 10):
		unique_effect = true
		return
	
	damage_bonus += 0.2

func get_description() -> String:
	var text = "Direct hits deal [color=red]" + String.num(100 * damage_bonus, 0) + "%[/color] more damage to frozen enemeis but break the freeze"
	if(unique_effect):
		text += "\nLvl [color=yellow]10[/color]: does something"
	return text

func remove_freezes(enemy: Enemy):
	var freezes = enemy.get_status(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN)
	for f in freezes:
		enemy.erase_status_effect(f)
