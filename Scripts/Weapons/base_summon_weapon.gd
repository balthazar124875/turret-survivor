extends BaseGun

class_name BaseSummon

@export var summon_scene: PackedScene

func _ready() -> void:
	create_new_summon()
	
func shoot(enemy: Node) -> void:
	return

func create_new_summon():
	enemy_parent = get_node("/root/EmilScene/Enemies")
	player = get_node("../..")
	var child = summon_scene.instantiate()
	child.parent_weapon = self
	child.player = player
	add_child(child)
	
func get_summon_damage() -> float: 
	return damage * gun_damage_multiplier * player.damageMultiplier

func apply_level_up():
	if(level == 5):
		create_new_summon()
	
	match level % 5:
		1:
			damage += 1
		2:
			cooldown *= 0.95
		3:
			range += 10
