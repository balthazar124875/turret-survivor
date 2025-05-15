extends AugmentUpgrade

@export var icicleBullet : PackedScene;
@export var base_projectile_speed = 350;
@export var bullet_life_time = 0.3;
@export var bullet_pierce = 1;
@export var damage = 5;

func _ready() -> void:
	SignalBus.enemy_killed.connect(on_enemy_killed)
	pass # Replace with function body.

func on_enemy_killed(enemy: Enemy):
	if enemy.has_status(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN):		
		var bulletAmount: int = 4 + player.extraProjectiles
		var direction = Vector2(1, 1)
		var spread = 360 / bulletAmount
		for n in range(bulletAmount):
			var bullet = icicleBullet.instantiate();
			add_child(bullet)
			bullet.global_position = enemy.global_position;
			bullet.init_with_direction(direction, damage * player.damageMultiplier, 
				base_projectile_speed * player.projectileSpeedMultipler, bullet_life_time, "Ice shards")
			bullet.pierce = bullet_pierce + player.extraPierce
			bullet.bounce += player.extraBounce
			direction = direction.rotated(-deg_to_rad(spread))
