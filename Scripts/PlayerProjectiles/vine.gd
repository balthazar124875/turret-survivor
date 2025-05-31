extends Area2D


@onready var _animated_sprite = $AnimatedSprite2D

@export var base_range : float = 200	
@export var duration : float = 1.5
@export var root_duration : float = 1

@export var damage : float = 1
@export var poison : bool = true

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

func HitEnemy(enemy : Enemy):
	rootEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED, root_duration, 1)
	var effects: Array[EnemyStatusEffect] = [rootEffect]
	
	if(poison):
		var poisonEffect = EnemyStatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED, root_duration, damage)
		effects.append(poisonEffect)
	enemy.take_hit(damage, "Vine", GlobalEnums.DAMAGE_TYPES.PHYSICAL, effects)
	
func _on_body_entered(body):
	if body is Enemy && !body in enemiesHit:  # Replace with your enemy script class name
		enemiesHit.push_back(body)
		HitEnemy(body)
