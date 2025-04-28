extends Enemy

class_name SplittingEnemy

@export var child_scene: PackedScene
@export var number_of_split_children: int = 3
	
func die() -> void:
	var angle_degrees = 360 / number_of_split_children
	for i in range(number_of_split_children):
		get_node("/root/EmilScene/EnemySpawner").spawn_enemy(child_scene, false, position + Vector2(40, 0).rotated(deg_to_rad(angle_degrees) * i))
	super.die()
