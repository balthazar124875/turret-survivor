extends Bullet

var knockback_speed = 150;
var knockback_distance = 50;

var target_size = 1
var grow_tween: Tween

var grow_speed = 0.5;

func _ready() -> void:
	super._ready()
	target_size = scale.x

func GrowLarger() -> void:
	damage *= 1.1;
	knockback_distance += 10;
	
	if(target_size >= 10):
		target_size == 10
		return
	
	target_size *= 1.10
	
	if grow_tween and grow_tween.is_valid():
		grow_tween.kill()

	grow_tween = create_tween()

	var start_scale = scale
	var final_scale = Vector2(target_size, target_size)

	grow_tween.tween_property(self, "scale", final_scale, grow_speed)
	

func _on_body_entered(body):
	super(body);
	if body is Enemy:
		GrowLarger();
	pass # Replace with function body.

func HitEnemy(body : Enemy):
	super(body)
	#Knockback(body)

func Knockback(enemy : Enemy) -> void:
	var vector_dir = (enemy.global_position - global_position).normalized() * knockback_distance
	enemy.add_displacement(vector_dir, knockback_speed)
