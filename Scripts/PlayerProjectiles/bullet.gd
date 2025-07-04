extends Area2D

class_name Bullet

var speed = 300
var direction: Vector2
var damage: float
var life_time: float = 3
var source: String

#behaviour modifiers
var pierce: int = 0
var bounce: float = 0
var dist

var effects: Array = []

@export var damage_type: GlobalEnums.DAMAGE_TYPES = GlobalEnums.DAMAGE_TYPES.PHYSICAL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	SignalBus.bullet_created.emit(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func init_with_target(target: Node, damage: float, speed: float, life_time: float, source: String) -> void:
	var current_position = global_position
	direction = (target.position - current_position).normalized()
	self.damage = damage
	self.life_time = life_time
	self.speed = speed
	self.source = source
	call_deferred("_delete_after_time", life_time)
	
func init_with_direction(direction: Vector2, damage: float, speed: float, life_time: float, source: String) -> void:
	self.direction = direction
	self.damage = damage
	self.life_time = life_time
	self.speed = speed
	self.rotation = direction.angle()
	self.source = source
	call_deferred("_delete_after_time", life_time)
	
func set_damage_type_and_color(damage_type: GlobalEnums.DAMAGE_TYPES, color: Color):
	self.damage_type = damage_type
	color_bullet(color)

func HitEnemy(body : Enemy):
	body.take_hit(damage, source, damage_type)  # Call the enemy's damage function
	for e in effects:
		e.call(body, self)

func _on_body_entered(body):
	if body is Enemy:  # Replace with your enemy script class name
		
		HitEnemy(body)
		if(pierce >= 1):
			pierce -= 1;
			return
		
		if(bounce >= 1):
			bounce -= 1;
			direction = direction.rotated(deg_to_rad(randf_range(90, 270)))
			self.rotation = direction.angle()
			self.damage *= 0.5
			return
		
		if(pierce == 0 && bounce == 0):
			queue_free()  # Destroy the bullet
			return
	
func color_bullet(color: Color):
	var sprite_node = get_node_or_null("AnimatedSprite2D")
	if sprite_node == null:
		sprite_node = get_node_or_null("Sprite2D")
	if sprite_node != null:
		sprite_node.modulate = color
	
func _delete_after_time(timeout):
	life_time -= timeout
	await get_tree().create_timer(timeout).timeout
	
	if(life_time > 0):
		call_deferred("_delete_after_time", life_time)
	else:
		queue_free()
