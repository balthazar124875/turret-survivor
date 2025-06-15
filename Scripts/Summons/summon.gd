extends Node2D

class_name Summon


var parent_weapon
var current_attack_cooldown = 0

var target_enemy: Enemy

@onready var enemy_parent = get_node("/root/EmilScene/Enemies")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_tweens()

func init_tweens():
	var original_scale = $Sprite2D.scale
	var rotation_tween = get_tree().create_tween().set_loops()
	rotation_tween.tween_property($Sprite2D, "rotation", deg_to_rad(10), 0.8).set_trans(Tween.TRANS_SINE)
	rotation_tween.tween_property($Sprite2D, "rotation", deg_to_rad(-10), 0.8).set_trans(Tween.TRANS_SINE)

	var scale_tween = get_tree().create_tween().set_loops()
	scale_tween.tween_property($Sprite2D, "scale", original_scale + Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property($Sprite2D, "scale", original_scale, 0.5).set_trans(Tween.TRANS_SINE)

func _process(delta: float) -> void:
	if current_attack_cooldown < parent_weapon.summon_attack_cooldown:
		current_attack_cooldown += delta
		
	if target_enemy == null:
		target_enemy = get_target()
	else:
		if target_enemy.global_position.distance_to(global_position) > parent_weapon.summon_range: 
			var direction = (target_enemy.global_position - global_position).normalized()
			global_position += direction * parent_weapon.summon_movement_speed * delta 
		elif current_attack_cooldown >= parent_weapon.summon_attack_cooldown:
			target_enemy.take_hit(parent_weapon.summon_damage, parent_weapon.source, parent_weapon.damage_type)
			current_attack_cooldown = 0


func get_target() -> Enemy:
	var closest_enemy: Enemy = null
	var shortest_distance: float = INF
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance && distance > parent_weapon.summon_range:
					shortest_distance = distance
					closest_enemy = enemy
					
	return closest_enemy
