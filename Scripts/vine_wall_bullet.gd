extends Node2D

class_name VineBullet

#TODO: Here the vinewall will damage enemies, animate etc, die etc
var hp : float;
var attackPower : float;
var spikedVine : bool;
var vineIdx : int;

var damage_flash_timer = Timer.new()
var damage_flash: bool = false
var player;

func instantiateVineWall(hpx : float, atkDmg : float, spiked : bool, idx : int) -> void:
	hp = hpx;
	attackPower = atkDmg;
	vineIdx = idx;
	spikedVine = spiked;
	if spikedVine:
		$Area2D/AnimatedSprite2DNoSpike.visible = false;
		$Area2D/AnimatedSprite2DSpike.visible = true;
		
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/EmilScene/Player")
	init_damage_flash_timer()
	pass # Replace with function body.

func init_damage_flash_timer():
	add_child(damage_flash_timer)  # Add the Timer to the node tree
	damage_flash_timer.wait_time = 0.2  # Set duration
	damage_flash_timer.one_shot = true  # Make it auto-stop
	damage_flash_timer.timeout.connect(_on_damage_flash_timeout)

#TODO: This needs to slow enemies
func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			HitEnemy(body, delta);

func take_damage(damage : int, enemy : Enemy):
	hp -= damage;
	damage_flash = true
	damage_flash_timer.start(0.1)
	if spikedVine:
		enemy.take_damage(attackPower * player.damageMultiplier);

func HitEnemy(body, delta) -> void:
	if body.GetObjectObstructingEnemy() == null:
		body.SetObjectObstructingEnemy(self);
	return;

func _on_damage_flash_timeout():
	damage_flash = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if damage_flash: 
		$Area2D/AnimatedSprite2DNoSpike.modulate = Color(1, 0, 0)
		$Area2D/AnimatedSprite2DSpike.modulate  = Color(1, 0, 0)
	else:
		$Area2D/AnimatedSprite2DNoSpike.modulate = Color(1, 1, 1)
		$Area2D/AnimatedSprite2DSpike.modulate  = Color(1, 1, 1)
	
	if hp <= 0:
		VineWall.registerVineDeath(vineIdx);
		queue_free();
	pass
