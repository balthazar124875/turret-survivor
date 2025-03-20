extends Node

class_name Player

var maxHealth = 100.0;
var health = 100.0;
var healthRegeneration = 0.0;
var playerUpgrades : Array = [];
var extraProjectiles = 0;
var extraChains = 0;
var rangeMultiplier = 1.0;
var damageMultiplier = 1.0;
var attackSpeedMultiplier = 1.0;
var projectileSpeedMultipler = 1.0;
var gold = 100;
var gold_income: int = 5;

@onready var income_timer: Timer = get_node("IncomeTimer")

static var playerOrbs : Array[BaseOrb] = [];
static var playerOrbsOuter : Array[BaseOrb] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modify_health(healthRegeneration * delta)

#TODO: REMOVE THIS
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			modify_gold(9999999)
	
func _on_income_timer_timeout() -> void:
	modify_gold(gold_income)

func heal_damage(value: float) -> void:
	modify_health(value)

func take_damage(value: float, source: Enemy) -> void:
	modify_health(-value)
	for playerUpgrade in playerUpgrades:
		if(playerUpgrade.type == Upgrade.UpgradeType.PASSIVE):
			if(playerUpgrade.passiveType == PassiveUpgrade.PassiveUpgradeType.ON_PLAYER_HIT):
				playerUpgrade.ApplyWhenHitEffect(self, source);

func modify_health(value: float) -> void:
	health += value
	if health >= maxHealth:
		health = maxHealth
	elif health <= 0:
		SignalBus.player_death.emit()
	SignalBus.player_health_updated.emit(health, maxHealth)

func modify_gold(value: int) -> void:
	gold += value
	SignalBus.gold_amount_updated.emit(gold)
	
func _on_enemy_killed(enemy: Enemy) -> void:
	for playerUpgrade in playerUpgrades:
		if(playerUpgrade.type == Upgrade.UpgradeType.PASSIVE):
			if(playerUpgrade.passiveType == PassiveUpgrade.PassiveUpgradeType.ENEMY_KILL_TYPE):
				playerUpgrade.ApplyEnemyOnKillPassive(enemy);
	modify_gold(enemy.gold_value)

func addPlayerBaseOrb(orb : BaseOrb):
	playerOrbs.push_back(orb);
	#Re-arrange them all in a circle
	ArrangePlayerOrbs(playerOrbs);

func ArrangePlayerOrbs(playerOrbs : Array):
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

func modify_stat(stat: GlobalEnums.PLAYER_STATS, amount: float) -> void:
	match (stat):
		GlobalEnums.PLAYER_STATS.ATTACK_SPEED:
			self.attackSpeedMultiplier += amount
		GlobalEnums.PLAYER_STATS.RANGE_MULTIPLER:
			self.rangeMultiplier += amount
		GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER:
			self.damageMultiplier += amount
		GlobalEnums.PLAYER_STATS.PROJECTILE_SPEED_MULTIPLIER:
			self.projectileSpeedMultipler += amount
		GlobalEnums.PLAYER_STATS.EXTRA_CHAINS:
			self.extraChains += amount
		GlobalEnums.PLAYER_STATS.EXTRA_PROJECTILES:
			self.extraProjectiles += amount
		GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME:
			self.gold_income += amount
		GlobalEnums.PLAYER_STATS.MULTIPLY_INCOME_TIMER:
			income_timer.wait_time = max(income_timer.wait_time * amount, 0.01)
		GlobalEnums.PLAYER_STATS.ADD_MAX_HEALTH:
			self.maxHealth += amount
			modify_health(amount)
		GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION:
			self.healthRegeneration += amount
