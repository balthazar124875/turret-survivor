extends Node2D

class_name VineBullet

#TODO: Here the vinewall will damage enemies, animate etc, die etc
var hp : float;
var attackPower : float;

func instantiateVineWall(hpx : float, atkDmg : float) -> void:
	hp = hpx;
	attackPower = atkDmg;
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#TODO: This needs to slow enemies
func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			HitEnemy(body, delta);

func take_damage(damage : int, enemy : Enemy):
	hp -= damage;
	enemy.take_damage(attackPower);

func HitEnemy(body, delta) -> void:
	if body.GetObjectObstructingEnemy() == null:
		body.SetObjectObstructingEnemy(self);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0:
		queue_free();
	pass
