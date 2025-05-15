extends Upgrade

class_name PassiveUpgrade

@onready var player = get_node("/root/EmilScene/Player")

@export var passiveType : PassiveUpgradeType;

enum PassiveUpgradeType {
	ENEMY_HIT_TYPE,
	ENEMY_KILL_TYPE,
	PROJECTILE_MODIFIER,
	ON_PLAYER_HIT,
	ON_BUY,
	ON_INCOME_TICK
}

func _ready() -> void:
	type = UpgradeType.PASSIVE
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	if(upgradeAmount == 1):
		reparentToPlayer(player)
	else:
		apply_level_up()

func reparentToPlayer(player: Player) -> void:
	player.get_node("./Upgrades/Passives").add_child(self)

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy, value: float) ->void:
	pass
	
func ApplyWhenIncomeTickEffect(player: Player) -> void:
	pass
	
func apply_level_up():
	pass
