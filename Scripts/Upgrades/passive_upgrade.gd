extends Upgrade

class_name PassiveUpgrade

var passiveType : PassiveUpgradeType;

enum PassiveUpgradeType {
	ENEMY_HIT_TYPE,
	ENEMY_KILL_TYPE,
	PROJECTILE_MODIFIER
}

func _ready() -> void:
	type = UpgradeType.PASSIVE
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	pass

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	pass
