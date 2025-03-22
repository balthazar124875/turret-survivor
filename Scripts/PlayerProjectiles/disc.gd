extends Bullet

class_name Disc

var outward_speed: float
var rotation_speed: float

@onready var player_position = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	SignalBus.bullet_created.emit(self)
	global_position += direction

func _physics_process(delta: float) -> void:
	rotation += 0.75
	global_position += (global_position - player_position.global_position).normalized() * outward_speed * delta
	global_position += (global_position - player_position.global_position).normalized().rotated(90) * rotation_speed * delta

func _delete_after_time(timeout):
	await get_tree().create_timer(timeout).timeout
	queue_free()
