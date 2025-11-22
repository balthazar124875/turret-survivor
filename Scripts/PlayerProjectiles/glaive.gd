extends Bullet

class_name Glaive

var extra_damage_on_chain = 0
var chain_range = 100
var chains = 1

var t = 0
var speed_ratio = 1
var target = Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.bullet_created.emit(self)

func init_with_target(target: Node, damage: float, speed: float, life_time: float, source: String) -> void:
	self.target = target
	self.damage = damage
	self.life_time = life_time
	self.speed = speed
	self.source = source
	call_deferred("_delete_after_time", life_time)
	

func HitEnemy(body : Enemy):
	super.HitEnemy(body)
	damage *= (1 + extra_damage_on_chain)
	
func find_new_target():
	var closest_enemy: Node = null
	var shortest_distance: float = INF
	var enemy_parent = get_node("/root/EmilScene/Enemies")
	if enemy_parent:
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive() && enemy != target:
				var distance = global_position.distance_to(enemy.global_position)
				if distance < shortest_distance && distance < chain_range:
					shortest_distance = distance
					closest_enemy = enemy
					
	if(closest_enemy):
		target = closest_enemy
	else:
		queue_free()	
	
func _process(delta: float) -> void:
	rotation += 0.75
	
	if(!is_instance_valid(target)):
		queue_free()
		return
	
	global_position += (target.global_position - global_position).normalized() * speed * delta
	
	if(target.global_position.distance_to(global_position) < 25):
		HitEnemy(target)
		chains -= 1
		if(chains > 0):
			find_new_target()
		else:
			queue_free()
			
func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	queue_free()
