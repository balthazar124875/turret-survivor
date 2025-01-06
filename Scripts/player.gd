extends Node

class_name Player

var hp = 100;
var playerUpgrades : Array = [];
var rangeMultiplier = 1.0;
var extraProjectiles = 2;
var gold = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for playerUpgrade in playerUpgrades:
		print(playerUpgrade.name);
	pass

func _addUpgrade(upgrade : Upgrade) -> void:
	if(upgrade.UpgradeType.PLAYER_STAT_UP):
		upgrade.applyStatUpgradeToPlayer(); #Call the statup upgrade callback function
	upgrade.applyUpgradeToPlayer();
	playerUpgrades.push_back(upgrade);

func modify_gold(value: int) -> void:
	gold += value
	SignalBus.gold_amount_updated.emit(gold)
	
func _on_enemy_killed(enemy: Enemy) -> void:
	modify_gold(enemy.gold_value)
