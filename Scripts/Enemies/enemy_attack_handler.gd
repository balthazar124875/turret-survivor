class_name EnemyAttackHandler

var enemy: Enemy
var sprite: Sprite2D

func _init(enemy: Enemy):
	self.enemy = enemy
	sprite = enemy.get_node("Sprite2D")

func attack() -> void:
	if(enemy is ExplodingEnemy):
		enemy.attack()
		return
	
	enemy.t = 0
	var tween = enemy.get_tree().create_tween()
	var original_scale = sprite.scale
	tween.set_parallel()
	var attack_position = enemy.player.global_position * 0.3 + enemy.global_position * 0.70
	tween.tween_property(sprite, "global_position", attack_position, 0.2).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(sprite, "scale", original_scale * 1.2, 0.2).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(sprite, "scale", original_scale, 0.2).set_trans(Tween.TRANS_SPRING).set_delay(0.2)
	tween.tween_property(sprite, "global_position", enemy.global_position, 0.2).set_trans(Tween.TRANS_SPRING).set_delay(0.2)
	enemy.player.take_damage(enemy.damage, enemy)
