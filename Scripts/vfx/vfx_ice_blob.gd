extends Bullet

var knockback_speed = 150;
var knockback_distance = 50;

func GrowLarger() -> void:
	self.scale += Vector2(0.1, 0.1);
	damage *= 1.1;
	knockback_distance += 10;

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
	if(enemy.get_status(GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED).size() == 0):
		enemy.add_displacement(vector_dir, knockback_speed)
