extends Node2D

@export var waves: Array[Wave] = []
@export var center: Node2D
@export var enemy_spawn_rate_multiplier = 1
@export var enemy_spawn_distance = 600
@export var random_spawn_offset = 50
@export var enemies: Node2D

@export var champion_spawn_rate: float = 0.1 

@export var enemy_hp_scaling = 1.25
@export var enemy_dmg_scaling = 1.15
@export var enemy_cc_effectiveness_scaling = 0.96
@export var enemy_speed_bonus_per_wave = 0.01
@export var double_enemies_every = 10

var rng = RandomNumberGenerator.new()
var current_wave_enemy_index = 0
var current_wave = 1

@export var enemy_outline_material: ShaderMaterial

@onready var wave_progress_bar: ProgressBar = get_node("/root/EmilScene/GameplayUi/LeftMenuColumn/WaveProgressBar")
@onready var wave_timer: Timer = get_node("WaveTimer")
@onready var enemy_spawn_timer: Timer = get_node("EnemySpawnerTimer")

#TODO: REMOVE THIS
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_V:
			_on_wave_timer_timeout()

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
		spawn_enemy(waves[current_wave_enemy_index].enemy, true)

func spawn_enemy(enemyScene: PackedScene, possibleChampion: bool, position: Vector2 = Vector2(0,0)):
	var enemy = enemyScene.instantiate()
	if(position != Vector2(0,0)):
		enemy.position = position
	else:
		var posRand = rng.randf_range(0, 360)
		var distance = enemy_spawn_distance + rng.randi_range(0, random_spawn_offset)
		var xPos = center.position.x + cos(posRand) * distance
		var yPos = center.position.y + sin(posRand) * distance
		enemy.position = Vector2(xPos, yPos)
	call_deferred("_spawn", enemy)
	enemy.modify_stats(pow(enemy_hp_scaling, current_wave / waves.size()),
	 pow(enemy_dmg_scaling, current_wave / waves.size()),
	 pow(enemy_cc_effectiveness_scaling, current_wave / waves.size()),
	 current_wave * enemy_speed_bonus_per_wave)
	
	var champ_r = randf_range(0, 1)
	if(possibleChampion && champ_r < champion_spawn_rate):
		enemy.get_node("Sprite2D").material = enemy_outline_material.duplicate()
		var type = randi_range(1, GlobalEnums.ENEMY_CHAMPION_TYPE.COUNT - 1)
		match type:
			GlobalEnums.ENEMY_CHAMPION_TYPE.REGENERATING:
				enemy.get_node("Sprite2D").material.set_shader_parameter("outline_color", Vector4(1, 0, 0, 1))
			GlobalEnums.ENEMY_CHAMPION_TYPE.JUGGERNAUT:
				enemy.get_node("Sprite2D").material.set_shader_parameter("outline_color", Vector4(0.1, 0, 0.6, 1))
			GlobalEnums.ENEMY_CHAMPION_TYPE.QUICK:
				enemy.get_node("Sprite2D").material.set_shader_parameter("outline_color", Vector4(1, 1, 0, 1))
			GlobalEnums.ENEMY_CHAMPION_TYPE.SPLITTING:
				enemy.get_node("Sprite2D").material.set_shader_parameter("outline_color", Vector4(1, 0, 1, 1))
				enemy.scene = enemyScene
				
		enemy.set_champion_type(type)

func _spawn(enemy):
	enemies.add_child(enemy)

func _on_wave_timer_timeout() -> void:
	current_wave += 1
	SignalBus.current_wave_updated.emit(current_wave)
	if current_wave_enemy_index < waves.size() - 1:
		current_wave_enemy_index += 1
	else:
		current_wave_enemy_index = 0

	enemy_spawn_timer.wait_time = waves[current_wave_enemy_index].spawn_interval * enemy_spawn_rate_multiplier
