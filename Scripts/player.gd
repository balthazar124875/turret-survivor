extends Node

class_name Player

var hp = 100;
var playerUpgrades : Array = [];
var rangeMultiplier = 1.0;
var extraProjectiles = 0;
var gold = 1000;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func modify_gold(value: int) -> void:
	gold += value
	SignalBus.gold_amount_updated.emit(gold)
	
func _on_enemy_killed(enemy: Enemy) -> void:
	for playerUpgrade in playerUpgrades:
		if(playerUpgrade.type == Upgrade.UpgradeType.PASSIVE):
			if(playerUpgrade.passiveType == PassiveUpgrade.PassiveUpgradeType.ENEMY_KILL_TYPE):
				playerUpgrade.ApplyEnemyOnKillPassive(enemy);
	modify_gold(enemy.gold_value)
