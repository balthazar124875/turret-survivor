extends Area2D


@onready var _animated_sprite = $AnimatedSprite2D

@export var base_range : float = 200	
@export var duration : float = 1.5

@export var damage : float = 1

var enemiesHit: Array = []

var t = 0

var rootEffect : EnemyStatusEffect

var maxScale = 1

@onready var player = get_node("/root/EmilScene/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("default")
	connect("body_entered", _on_body_entered)
	
	var h = _animated_sprite.sprite_frames.get_frame_texture("default",0).get_height()/2
	maxScale = base_range  / h

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * 2
	var size = t * player.projectileSpeedMultipler
	
	if(t <= 1):
		scale = Vector2(1 * player.areaSizeMultiplier, size * maxScale)
	else:
		_animated_sprite.speed_scale = 0
	
	if t > duration:
		queue_free()
	
	pass

func HitEnemy(body : Enemy):
	body.take_damage(damage, "Vine")  # Call the enemy's damage function
	SignalBus.on_enemy_hit.emit(body)
	rootEffect = EnemyStatusEffect.new()
	rootEffect.type = GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED
	rootEffect.duration = 2
	rootEffect.magnitude = 0
	body.apply_status_effect(rootEffect)
	
func _on_body_entered(body):
	if body is Enemy && !body in enemiesHit:  # Replace with your enemy script class name
		enemiesHit.push_back(body)
		HitEnemy(body)
