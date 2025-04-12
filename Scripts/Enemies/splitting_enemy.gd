extends Enemy

class_name SplittingEnemy

@export var child_scene: PackedScene
@export var number_of_split_children: int = 3
	
func die() -> void:
	var angle_degrees = 360 / number_of_split_children
	for i in range(number_of_split_children):
		var child = child_scene.instantiate()
		child.position = position + Vector2(40, 0).rotated(deg_to_rad(angle_degrees) * i)
		child.set_linear_velocity(Vector2(10,10))
		get_node("/root/EmilScene/Enemies").add_child(child)
	super.die()
