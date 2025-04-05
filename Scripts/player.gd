extends Node

class_name Player

@export var maxHealth = 100.0;
@export var health = 100.0;
@export var healthRegeneration: float = 0.0;
var playerUpgrades: Array = [];
@export var extraProjectiles = 0;
@export var extraChains = 0;
@export var rangeMultiplier = 1.0;
@export var damageMultiplier = 1.0;
@export var attackSpeedMultiplier = 1.0;
@export var projectileSpeedMultipler = 1.0;
@export var areaSizeMultiplier = 1.0;
@export var luck = 0;
@export var armor: float = 0.0;
# https://warcraft3.info/articles/208/overview-of-armor-and-damage-reduction
# Each 0.01 gives 1% more effective health points per armor point
@export var armor_damage_reduction_const = 0.05
var gold: int = 100;
var gold_income: int = 5;

var ENABLE_BOUNTY = false

@onready var income_timer: Timer = get_node("IncomeTimer")
@onready var damage_flash_timer: Timer = get_node("DamageFlashTimer")

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
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ON_INCOME_TICK):
		upgrade.ApplyWhenIncomeTickEffect(self)


func heal_damage(value: float, source: String) -> void:
	modify_health(value)
	SignalBus.heal_done.emit(value, source)

func take_damage(value: float, source: Enemy) -> void:
	modify_health(-damage_after_armor_reduction(value))
	damage_flash_timer.start(0.1)
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ON_PLAYER_HIT)
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ON_PLAYER_HIT):
		upgrade.ApplyWhenHitEffect(self, source);

func damage_after_armor_reduction(value: float) -> float:
	return value - (armor * armor_damage_reduction_const) / (1 + armor_damage_reduction_const * armor)

func modify_health(value: float) -> void:
	health += value
	if health >= maxHealth:
		health = maxHealth
	elif health <= 0:
		SignalBus.player_death.emit()
	SignalBus.player_health_updated.emit(health, maxHealth)
	
func modify_max_health(value: float) -> void:
	maxHealth += value
	
	if maxHealth <= 0:
		SignalBus.player_death.emit()
	if health >= maxHealth:
		health = maxHealth
	
	SignalBus.player_health_updated.emit(health, maxHealth)

func modify_health_regeneration(value: float) -> void:
	healthRegeneration += value

func modify_gold(value: int) -> void:
	gold += value
	SignalBus.gold_amount_updated.emit(gold)
	
func modify_income(value: int) -> void:
	gold_income += value

func modify_armor(value: float, source: String) -> void:
	armor += value
	SignalBus.armor_updated.emit(armor, source)
	
func _on_enemy_killed(enemy: Enemy) -> void:
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ENEMY_KILL_TYPE):
		upgrade.ApplyEnemyOnKillPassive(enemy);
	if ENABLE_BOUNTY:
		modify_gold(enemy.gold_value)

func modify_stat(stat: GlobalEnums.PLAYER_STATS, amount: float, source: String) -> void:
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
		GlobalEnums.PLAYER_STATS.BONUS_LUCK:
			self.luck += amount
		GlobalEnums.PLAYER_STATS.ADD_ARMOR:
			modify_armor(amount, source)

func get_passive_upgrades_of_type(upgrade_type: PassiveUpgrade.PassiveUpgradeType):
	return playerUpgrades.filter(func(e: Upgrade): return e.type == Upgrade.UpgradeType.PASSIVE && e.passiveType == upgrade_type)

func _on_damage_flash_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
