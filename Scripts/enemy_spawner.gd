extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var center: Node2D
@export var enemy_spawn_delay = 0.1
@export var enemy_spawn_distance = 300
@export var enemies: Node2D


var rng = RandomNumberGenerator.new()
var current_wave_enemy_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_spawner_timer_timeout() -> void:
	var enemy = enemy_scenes[current_wave_enemy_index].instantiate()
	var posRand = rng.randf_range(0, 360)
	var xPos = center.position.x + cos(posRand) * enemy_spawn_distance
	var yPos = center.position.y + sin(posRand) * enemy_spawn_distance
	enemy.position = Vector2(xPos, yPos)
	enemies.add_child(enemy)

func _on_wave_timer_timeout() -> void:
	if current_wave_enemy_index < enemy_scenes.size() - 1:
		current_wave_enemy_index += 1
	else:
		current_wave_enemy_index = 0

	print("Current wave enemy index: ", current_wave_enemy_index)
