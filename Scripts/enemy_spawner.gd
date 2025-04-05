extends Node2D

@export var waves: Array[Wave] = []
@export var center: Node2D
@export var enemy_spawn_rate_multiplier = 1
@export var enemy_spawn_distance = 600
@export var enemies: Node2D

@export var enemy_hp_scaling = 1.25
@export var enemy_dmg_scaling = 1.05
@export var double_enemies_every = 10


var rng = RandomNumberGenerator.new()
var current_wave_enemy_index = 0
var current_wave = 1

@onready var wave_progress_bar: ProgressBar = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/WaveProgressBar")
@onready var wave_timer: Timer = get_node("WaveTimer")
@onready var enemy_spawn_timer: Timer = get_node("EnemySpawnerTimer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_progress_bar.max_value = wave_timer.wait_time
	enemy_spawn_timer.wait_time = waves[current_wave_enemy_index].spawn_interval

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave_progress_bar.value = wave_timer.time_left

func _on_enemy_spawner_timer_timeout() -> void:
	
	var r = rng.randi_range(0, current_wave)
	var amount = 1 + (r / double_enemies_every) 
	
	for i in range (amount):
		var enemy = waves[current_wave_enemy_index].enemy.instantiate()
		var posRand = rng.randf_range(0, 360)
		var xPos = center.position.x + cos(posRand) * enemy_spawn_distance
		var yPos = center.position.y + sin(posRand) * enemy_spawn_distance
		enemy.position = Vector2(xPos, yPos)
		enemies.add_child(enemy)
		enemy.increase_hp(pow(enemy_hp_scaling, current_wave / waves.size()))
		enemy.increase_damage(pow(enemy_dmg_scaling, current_wave / waves.size()))

func _on_wave_timer_timeout() -> void:
	current_wave += 1
	SignalBus.current_wave_updated.emit(current_wave)
	if current_wave_enemy_index < waves.size() - 1:
		current_wave_enemy_index += 1
	else:
		current_wave_enemy_index = 0

	enemy_spawn_timer.wait_time = waves[current_wave_enemy_index].spawn_interval * enemy_spawn_rate_multiplier
