extends Node2D

class_name BaseGun

enum TargetingType {
	ENEMY,
	AREA
}

@export var targeting_type : TargetingType;
@export var bullet: PackedScene

@export var cooldown: float = 0.2 #0.2s delay between each shot => firerate = cooldown/1
@export var damage: float = 1 #increment this for increasing strength of guns
@export var gun_damage_multiplier: float = 1 #fixed per weapon, changes how much different weapons scale on bonus damage
@export var charge: float = 0
@export var base_projectile_speed: float = 300
@export var bullet_life_time: float = 2
@export var range: float = 0
@export var level: int = 1
@export var pierce: int = 0
@export var base_projectile_amount: float = 1
@export var source: String = ""

var localAttackSpeedBonus: float = 1

var player: Player
var enemy_parent: Node = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_parent = get_node("/root/EmilScene/Enemies")
	player = get_node("../..")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	charge += delta * player.attackSpeedMultiplier * localAttackSpeedBonus
	if(charge > cooldown):
		match (targeting_type):
			TargetingType.ENEMY:
				var enemy = get_target()
				if(enemy != null):
					shoot(enemy)
					charge = fmod(charge,  cooldown)
			TargetingType.AREA:
				var area = get_target_area()
				shoot_area(area)
				charge = fmod(charge,  cooldown)
				

func get_target() -> Node: #defaults to getting closest
	var closest_enemy: Node = null
	var shortest_distance: float = INF
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance && (range == 0 || distance < range * player.rangeMultiplier):
					shortest_distance = distance
					closest_enemy = enemy
					
	return closest_enemy
	
	
func get_target_area() -> Vector2: #defaults to getting closest
	var screenSize = get_viewport().get_visible_rect().size;
	var distance = randf_range(100, min(range * player.rangeMultiplier, screenSize.y / 2))
	var angle = randf_range(0, PI * 2)
	
	var position = Vector2(1 , 1);
	position = position.rotated(angle)
	position *= distance
	
	position += player.global_position
	return position

func shoot(enemy: Node) -> void:
	enemy.take_damage(damage)
	
func shoot_area(position: Vector2) -> void:
	var obj = bullet.instantiate()
	add_child(obj)
	obj.global_position = position
	
func level_up():
	level += 1
	apply_level_up()
	
func apply_level_up():
	pass
