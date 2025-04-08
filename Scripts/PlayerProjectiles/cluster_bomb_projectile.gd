extends Bullet

class_name ClusterBombProjectile

@onready var cluster_bomb_scene = preload("res://Scenes/Projectiles/cluster_bomb_projectile.tscn")
@onready var explosionVFX = preload("res://Scenes/vfx/vfx_explosion.tscn");
@onready var player = get_node("/root/EmilScene/Player")
@onready var sprite = $Sprite2D

var start_pos: Vector2
var target_pos: Vector2

var path: Path2D
var path_follow: PathFollow2D

var cluster_times = 1

var spread_radius: float = 150
var cluster_speed_mult: float = 1.5
var arc_height: float  = 100

var number_of_cluster_bombs = 3

var base_explosion_size = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.bullet_created.emit(self)
	path = Path2D.new()
	path_follow = PathFollow2D.new()
	
	var curve = Curve2D.new()
	curve.add_point(start_pos)
	curve.add_point((start_pos + target_pos) / 2 - Vector2(0, arc_height))  # Arc control point
	curve.add_point(target_pos)
	
	path.curve = curve
	add_child(path)
	path.add_child(path_follow)
	
	path.curve.set_point_out(0, Vector2(target_pos.x / 2, -abs(target_pos.x)))
	path.curve.set_point_position(1, target_pos)
	sprite.rotation_degrees = randf_range(0,360)

func _process(delta) -> void:
	# Spin sprite
	sprite.rotate(7 * delta)
	
	if path_follow.progress_ratio >= 0.95:
		create_explosion()
		damage_enemies_in_collider()
		if cluster_times > 0:
			cluster()
		queue_free()
		
	path_follow.progress += speed * delta
	position = path_follow.position
	
func get_random_point_on_circle(radius: float) -> Vector2:
	var angle = randf_range(0, TAU) 
	return Vector2(cos(angle), sin(angle)) * radius

func cluster():
	for i in number_of_cluster_bombs:
		var new_bomb = cluster_bomb_scene.instantiate()
		new_bomb.start_pos = target_pos
		new_bomb.target_pos = target_pos + get_random_point_on_circle(spread_radius)
		new_bomb.speed = speed 
		new_bomb.arc_height = 50
		new_bomb.damage = damage
		new_bomb.cluster_times = cluster_times - 1 if i == 0 else 0
		new_bomb.number_of_cluster_bombs = number_of_cluster_bombs
		get_parent().add_child(new_bomb)
		
func create_explosion():
	var explosion = explosionVFX.instantiate()
	explosion.position = position
	explosion.set_particle_scale(base_explosion_size * 2 * player.areaSizeMultiplier)
	$CollisionShape2D.shape.radius = base_explosion_size * player.areaSizeMultiplier
	get_parent().add_child(explosion)
	
func damage_enemies_in_collider():
	var enemies = []
	for body in get_overlapping_bodies():
		if body is Enemy:  # Check if it's an enemy
			body.take_damage(damage, "Cluster bomb")
#func _delete_after_time(timeout):
	#await get_tree().create_timer(timeout).timeout
	#queue_free()
