extends PassiveUpgrade

@export var damage_bonus_per_effect = 0.01 #10%

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
	var statuses = enemy.active_status_effects
	
	var unique_effects := {}
	for effect in statuses:
		unique_effects[effect.type] = true
	
	var bonus_damage = hit.amount * (damage_bonus_per_effect * unique_effects.size())
	hit.bonus_damage += bonus_damage
				
func apply_level_up():
	if(upgradeAmount == 10):
		unique_effect = true
		return
	
	damage_bonus_per_effect += 0.01

func get_description() -> String:
	var text = "You deal [color=red]" + String.num(100 * damage_bonus_per_effect, 0) + "%[/color] more damage for each unique status effect on the enemy"
	if(unique_effect):
		text += "\nLvl [color=yellow]10[/color]: does something"
	return text
