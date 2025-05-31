extends Node

class_name Player

@export var maxHealth = 100.0;
@export var health = 100.0;
@export var healthRegeneration: float = 3;
var playerUpgrades: Array = [];
@export var extraProjectiles = 0;
@export var extraChains = 0;
@export var extraPierce = 0;
@export var extraBounce = 0;
@export var rangeMultiplier = 1.0;
@export var damageMultiplier = 1.0;
@export var attackSpeedMultiplier = 1.0;
@export var projectileSpeedMultipler = 1.0;
@export var areaSizeMultiplier = 1.0;
@export var luck = 0;
@export var armor: float = 0.0;
@export var healing_multiplier: float = 1.0
# https://warcraft3.info/articles/208/overview-of-armor-and-damage-reduction
# Each 0.01 gives 1% more effective health points per armor point
@export var armor_damage_reduction_const = 0.05
# <DAMAGE_TYPE, float>
@export var damage_type_multipliers: Dictionary = {}

@export var championRewardBonus: float = 1;

var gold: int = 50;
var gold_income: int = 10;
var interest_per_amount: int = 10;
var interest_cap: int = 10;

var ENABLE_BOUNTY = false

@onready var income_timer: Timer = get_node("IncomeTimer")
@onready var damage_flash_timer: Timer = get_node("DamageFlashTimer")

var circle;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	circle = get_node("./Circle");
	init_damage_type_multipliers()
	SignalBus.enemy_killed.connect(_on_enemy_killed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	heal_damage(healthRegeneration * delta, "Regeneration")

func init_damage_type_multipliers():
	for key in GlobalEnums.DAMAGE_TYPES.values():
		damage_type_multipliers[key] = 1.0
	

#TODO: REMOVE THIS
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			modify_gold(9999999)
		if event.keycode == KEY_X:
			for node in get_node("/root/EmilScene/Enemies/").get_children():
				node.queue_free()
	
func _on_income_timer_timeout() -> void:
	var interest = get_interest()
	modify_gold(gold_income + interest)
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ON_INCOME_TICK):
		upgrade.ApplyWhenIncomeTickEffect(self)
	SignalBus.income_recieved.emit()

func get_interest() -> int:
	var interest = (gold / interest_per_amount) as int
	return min(interest_cap, interest)

func heal_damage(value: float, source: String) -> void:
	var result = healing_multiplier * value
	modify_health(result)
	SignalBus.heal_done.emit(result, source)

func take_damage(value: float, source: Enemy) -> void:
	var after_armor_value = damage_after_armor_reduction(value)
	modify_health(-after_armor_value)
	damage_flash_timer.start(0.1)
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ON_PLAYER_HIT):
		upgrade.ApplyWhenHitEffect(self, source, after_armor_value);

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
	SignalBus.gold_amount_updated.emit()
	if(value < 0):
		SignalBus.gold_spent.emit(value)
	
func modify_income(value: int) -> void:
	gold_income += value
	
func _on_enemy_killed(enemy: Enemy) -> void:
	for upgrade in get_passive_upgrades_of_type(PassiveUpgrade.PassiveUpgradeType.ENEMY_KILL_TYPE):
		upgrade.ApplyEnemyOnKillPassive(enemy);
	if ENABLE_BOUNTY:
		modify_gold(enemy.gold_value)
		
	match enemy.champion_type:
		GlobalEnums.ENEMY_CHAMPION_TYPE.QUICK:
			modify_stat(GlobalEnums.PLAYER_STATS.ATTACK_SPEED, championRewardBonus * 0.005)
		GlobalEnums.ENEMY_CHAMPION_TYPE.REGENERATING:
			modify_stat(GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION, championRewardBonus * 0.2)
		GlobalEnums.ENEMY_CHAMPION_TYPE.JUGGERNAUT:
			modify_stat(GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER, championRewardBonus *0.005)
		GlobalEnums.ENEMY_CHAMPION_TYPE.SPLITTING:
			modify_stat(GlobalEnums.PLAYER_STATS.PROJECTILE_SPEED_MULTIPLIER, championRewardBonus * 0.005)
		

func modify_stat(stat: GlobalEnums.PLAYER_STATS, amount: float, source: String = "") -> void:
	match (stat):
		GlobalEnums.PLAYER_STATS.ATTACK_SPEED:
			self.attackSpeedMultiplier += amount
			SignalBus.stat_updated.emit(stat, self.attackSpeedMultiplier, amount)
		GlobalEnums.PLAYER_STATS.RANGE_MULTIPLER:
			self.rangeMultiplier += amount
			SignalBus.stat_updated.emit(stat, self.rangeMultiplier, amount)
		GlobalEnums.PLAYER_STATS.DAMAGE_MULTIPLIER:
			self.damageMultiplier += amount
			SignalBus.stat_updated.emit(stat, self.damageMultiplier, amount)
		GlobalEnums.PLAYER_STATS.PROJECTILE_SPEED_MULTIPLIER:
			self.projectileSpeedMultipler += amount
			SignalBus.stat_updated.emit(stat, self.projectileSpeedMultipler, amount)
		GlobalEnums.PLAYER_STATS.AREA_SIZE_MULTIPLIER:
			self.areaSizeMultiplier += amount
			SignalBus.stat_updated.emit(stat, self.areaSizeMultiplier, amount)
		GlobalEnums.PLAYER_STATS.EXTRA_CHAINS:
			self.extraChains += amount
			SignalBus.stat_updated.emit(stat, self.extraChains, amount)
		GlobalEnums.PLAYER_STATS.EXTRA_PROJECTILES:
			self.extraProjectiles += amount
			SignalBus.stat_updated.emit(stat, self.extraProjectiles, amount)
		GlobalEnums.PLAYER_STATS.ADD_BASE_INCOME:
			self.gold_income += amount
			SignalBus.stat_updated.emit(stat, self.gold_income, amount)
		GlobalEnums.PLAYER_STATS.MULTIPLY_INCOME_TIMER:
			income_timer.wait_time = max(income_timer.wait_time * amount, 0.01)
			SignalBus.stat_updated.emit(stat, income_timer.wait_time, amount)
		GlobalEnums.PLAYER_STATS.ADD_MAX_HEALTH:
			self.maxHealth += amount
			modify_health(amount)
			SignalBus.stat_updated.emit(stat, maxHealth, amount)
		GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION:
			self.healthRegeneration += amount
			SignalBus.stat_updated.emit(stat, self.healthRegeneration, amount)
		GlobalEnums.PLAYER_STATS.ADD_ARMOR:
			self.armor += amount
			SignalBus.stat_updated.emit(stat, self.armor, amount)
		GlobalEnums.PLAYER_STATS.BONUS_LUCK:
			self.luck += amount
			SignalBus.stat_updated.emit(stat, self.luck, amount)
		GlobalEnums.PLAYER_STATS.BONUS_PIERCE:
			self.extraPierce += amount
			SignalBus.stat_updated.emit(stat, self.extraPierce, amount)
		GlobalEnums.PLAYER_STATS.BONUS_BOUNCE:
			self.extraBounce += amount
			SignalBus.stat_updated.emit(stat, self.extraBounce, amount)

func GetDamageMultiplier(damage_type : GlobalEnums.DAMAGE_TYPES, enemyPos : Vector2) -> float:
	var damage_multiplier = damage_type_multipliers[damage_type]
	#Check circle buffs
	var IsWithinInnerOrOuterCircle : Circle.CircleType = Circle.IsPositionWithinInnerCircle(enemyPos);
	damage_multiplier *= circle.damage_type_multipliers[IsWithinInnerOrOuterCircle][damage_type];
	return damage_multiplier;

func get_passive_upgrades_of_type(upgrade_type: PassiveUpgrade.PassiveUpgradeType):
	return playerUpgrades.filter(func(e: Upgrade): return e.type == Upgrade.UpgradeType.PASSIVE && e.passiveType == upgrade_type)

func _on_damage_flash_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	
func get_random_weapon(tag: String = "") -> WeaponUpgrade:
	var matching_children := []
	var weapons = playerUpgrades.filter(func(e: Upgrade): return e.type == Upgrade.UpgradeType.WEAPON)
	for child in weapons:
		if tag.to_lower() in child.name.to_lower():
			matching_children.append(child)

	if matching_children.size() > 0:
		return matching_children[randi() % matching_children.size()]
	else:
		return null
