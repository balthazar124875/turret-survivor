extends AugmentUpgrade

@export var duration = 5
@export var armor = 40

func _ready() -> void:
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_ARMOR, armor, "BLOOD CONTROL");
	
func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) -> void:
	var bleed = StatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.BLEEDING, duration, value/( 2 * duration))
	player.apply_status_effect(bleed)

func get_description() -> String:
	return "Grants [color=red]" + str(armor) + "[/color]  armor. Taking damage causes player to bleed for additional [color=red]100%[/color] damage over [color=yellow]" + str(duration) + "[/color] seconds"
