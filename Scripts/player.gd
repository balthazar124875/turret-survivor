extends Node

class_name Player

var hp = 100;
var playerUpgrades : Array = [];
var rangeMultiplier = 1.0;
var extraProjectiles = 0;
var gold = 1000;

static var playerOrbs : Array[FireOrb] = [];
static var playerOrbsOuter : Array[FireOrb] = [];

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

static func addPlayerFireOrb(orb : FireOrb):
	playerOrbs.push_back(orb);
	#Re-arrange them all in a circle
	ArrangePlayerOrbs(playerOrbs);

static func ArrangePlayerOrbs(playerOrbs : Array):
	if(playerOrbs.size() == 0):
		return
	var nrOfOrbs = playerOrbs.size();
	var angle = (360.0 / nrOfOrbs);
	var i = 0;
	angle = deg_to_rad(angle);
	for x in playerOrbs:
		x.nextAngle = angle*i;
		var orbPos = Vector2(sin(x.nextAngle), cos(x.nextAngle))*x.orbRange;
		x.nextPos = orbPos;
		x.currAngle = (playerOrbs[0].currAngle) + angle*i;
		i += 1;
	pass
