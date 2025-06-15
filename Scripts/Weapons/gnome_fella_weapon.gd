extends BaseGun

class_name GnomeFellaWeapon

@export var gnome_scene: PackedScene
@export var summon_damage: float = 1
@export var summon_movement_speed: float = 50
@export var summon_attack_cooldown: float = 1
@export var summon_range: float = 10

func _ready() -> void:
	create_new_summon()

func create_new_summon():
	enemy_parent = get_node("/root/EmilScene/Enemies")
	player = get_node("../..")
	var child = gnome_scene.instantiate()
	child.parent_weapon = self
	add_child(child)

func apply_level_up():
	if(level == 5):
		create_new_summon()
	
	match level % 5:
		1:
			summon_damage += 1
		2:
			summon_attack_cooldown *= 0.95
		3:
			summon_range += 10
