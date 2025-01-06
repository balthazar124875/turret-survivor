extends Node2D

class_name BaseGun
@export var bullet: PackedScene

@export var cooldown: float = 0.2 #0.2s delay between each shot => firerate = cooldown/1
@export var damage: float = 1
@export var charge: float = 0

var player: Player
var enemy_parent: Node = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_parent = get_node("/root/EmilScene/Enemies")
	player = get_node("../..")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	charge += delta
	if(charge > cooldown):
		var enemy = get_target()
		if(enemy != null):
			shoot(enemy)
			charge = fmod(charge,  cooldown)
	
	pass

func get_target() -> Node: #defaults to getting closest
	var closest_enemy: Node = null
	var shortest_distance: float = INF
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance:
					shortest_distance = distance
					closest_enemy = enemy
					
	return closest_enemy


func shoot(enemy: Node) -> void:
	enemy.take_damage(damage)
