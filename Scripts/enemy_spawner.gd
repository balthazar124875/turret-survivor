extends Node2D

@export var test_enemy_scene: PackedScene
@export var center: Node2D
@export var enemy_spawn_delay = 0.1
@export var enemy_spawn_distance = 300

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_spawner_timer_timeout() -> void:
	var enemy = test_enemy_scene.instantiate()
	var posRand = rng.randf_range(0, 360)
	var xPos = center.position.x + cos(posRand) * enemy_spawn_distance
	var yPos = center.position.y + sin(posRand) * enemy_spawn_distance
	enemy.position = Vector2(xPos, yPos)
	add_child(enemy)
	
