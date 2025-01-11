extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var center: Node2D
@export var enemy_spawn_delay = 0.1
@export var enemy_spawn_distance = 200
@export var enemies: Node2D

@export var enemy_hp_scaling = 1.2
@export var double_enemies_every = 10


var rng = RandomNumberGenerator.new()
var current_wave_enemy_index = 0
var current_wave = 1

@onready var wave_progress_bar: ProgressBar = get_node("/root/EmilScene/Control/WaveProgressBar")
@onready var wave_timer: Timer = get_node("WaveTimer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_progress_bar.max_value = wave_timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave_progress_bar.value = wave_timer.time_left

func _on_enemy_spawner_timer_timeout() -> void:
	
	var r = rng.randi_range(0, current_wave)
	var amount = 1 + (r / double_enemies_every) 
	print(amount)
	
	for i in range (amount):
		var enemy = enemy_scenes[current_wave_enemy_index].instantiate()
		var posRand = rng.randf_range(0, 360)
		var xPos = center.position.x + cos(posRand) * enemy_spawn_distance
		var yPos = center.position.y + sin(posRand) * enemy_spawn_distance
		enemy.position = Vector2(xPos, yPos)
		enemies.add_child(enemy)
		enemy.increase_hp(pow(1.2, current_wave / enemy_scenes.size()))

func _on_wave_timer_timeout() -> void:
	current_wave += 1
	SignalBus.current_wave_updated.emit(current_wave)
	if current_wave_enemy_index < enemy_scenes.size() - 1:
		current_wave_enemy_index += 1
	else:
		current_wave_enemy_index = 0

	print("Current wave enemy index: ", current_wave_enemy_index)
