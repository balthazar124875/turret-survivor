extends Node

class_name Player

@export var maxHealth = 100.0;
@export var health = 100.0;
@export var healthRegeneration = 0.0;
var playerUpgrades : Array = [];
@export var extraProjectiles = 0;
@export var extraChains = 0;
@export var rangeMultiplier = 1.0;
@export var damageMultiplier = 1.0;
@export var attackSpeedMultiplier = 1.0;
@export var projectileSpeedMultipler = 1.0;
@export var areaSizeMultiplier = 1.0;
var gold = 100;
var gold_income: int = 5;

var ENABLE_BOUNTY = false

@onready var income_timer: Timer = get_node("IncomeTimer")
@onready var damage_flash_timer: Timer = get_node("DamageFlashTimer")

static var playerOrbs : Array[BaseOrb] = [];
static var playerOrbsOuter : Array[BaseOrb] = [];
static var maxNrInnerOrbs : int;
static var maxNrOuterOrbs : int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_killed.connect(_on_enemy_killed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	heal_damage(healthRegeneration * delta, "Regeneration")

#TODO: REMOVE THIS
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			modify_gold(9999999)
		if event.keycode == KEY_X:
			for node in get_node("/root/EmilScene/Enemies/").get_children():
				node.queue_free()
	
func _on_income_timer_timeout() -> void:
	modify_gold(gold_income)

func heal_damage(value: float, source: String) -> void:
	modify_health(value)
	SignalBus.heal_done.emit(value, source)

func take_damage(value: float, source: Enemy) -> void:
	modify_health(-value)
	damage_flash_timer.start(0.1)
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
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
	if ENABLE_BOUNTY:
		modify_gold(enemy.gold_value)

func addPlayerBaseOrb(orb : BaseOrb):
	#if(maxNrInnerOrbs)
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
		GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER:
			self.areaSizeMultiplier += amount
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


func _on_damage_flash_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
