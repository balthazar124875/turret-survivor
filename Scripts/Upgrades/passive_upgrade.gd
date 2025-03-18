extends Upgrade

class_name PassiveUpgrade

@export var passiveType : PassiveUpgradeType;

enum PassiveUpgradeType {
	ENEMY_HIT_TYPE,
	ENEMY_KILL_TYPE,
	PROJECTILE_MODIFIER,
	ON_PLAYER_HIT
}

func _ready() -> void:
	type = UpgradeType.PASSIVE
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	#level up passive
	
	pass

func reparentToPlayer(player: Player) -> void:
	self.reparent(player.get_node("./Upgrades/Passives"))

func ApplyEnemyOnKillPassive(enemy : Enemy) ->void:
	pass

func ApplyWhenHitEffect(player: Player, enemy : Enemy) ->void:
	pass
