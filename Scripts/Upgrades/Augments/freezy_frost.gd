extends AugmentUpgrade

@export var duration = 1.0 #10%
@export var hp_threshold_scaling = 1

func _ready() -> void:
	SignalBus.before_enemy_take_hit.connect(_before_hit)
	pass # Replace with function body.

func _before_hit(hit: Hit, enemy: Enemy):
	if(hit.type == GlobalEnums.DAMAGE_TYPES.ICE):
		var percentage_of_hp = hit.amount/enemy.max_health
		
		var rndNumber = randf_range(0.0, 1.0);
		if(rndNumber <= percentage_of_hp * hp_threshold_scaling):
			var freeze = StatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN, duration, 1)
			hit.on_hit_effects.append(freeze)

func get_description() -> String:
	var text = "Cold damage might freeze enemies for [color=yellow]" + str(duration) + "[/color] seconds depending on damage dealt"
	return text
