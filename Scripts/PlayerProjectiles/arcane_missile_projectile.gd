extends RigidBody2D

var speed = 300
var damage: float
var life_time: float = 5
var source: String

var effects: Array = []

var target: Enemy

@export var damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_random_target()
	SignalBus.bullet_created.emit(self)
	await get_tree().create_timer(life_time).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	linear_velocity *= 0.95
	if(target != null):
		apply_force((target.global_position - global_position).normalized() * 9000 * delta)
	else:
		target = get_random_target()

func get_random_target() -> Node2D:
	var enemies = get_node("/root/EmilScene/Enemies").get_children()
	return enemies.pick_random() if enemies.size() > 0 else null

func HitEnemy(body : Enemy):
	body.take_hit(damage, source, damage_type)  # Call the enemy's damage function
	for e in effects:
		e.call(body, self)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(target == null):
		return
	if body.get_instance_id() == target.get_instance_id():
		HitEnemy(body)
