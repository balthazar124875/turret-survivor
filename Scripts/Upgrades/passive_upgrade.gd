extends Upgrade

class_name PassiveUpgrade

@export var weapon_scene : PackedScene;
var passiveType : PassiveUpgradeType;

enum PassiveUpgradeType {
	ENEMY_HIT_TYPE,
	ENEMY_KILL_TYPE,
}

func _ready() -> void:
	type = UpgradeType.PASSIVE
	pass # Replace with function body.

func applyUpgradeToPlayer() -> void:
	pass

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	pass
