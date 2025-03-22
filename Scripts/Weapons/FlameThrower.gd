extends BaseGun

class_name FlameThrower

@export var flameThrowerVfx : PackedScene
var flame_thrower_instance : Node2D
var ftParticles : GPUParticles2D
var IsShooting : bool;
var targettedEnemy : Node2D;

func _ready() -> void:
	super()
	IsShooting = false;
	var flame_thrower_instance = flameThrowerVfx.instantiate();
	add_child(flame_thrower_instance)
	flame_thrower_instance.global_position = player.global_position;
	ftParticles = flame_thrower_instance.get_node("GPUParticles2D");
	ftParticles.global_position = player.global_position;
	targettedEnemy = null;
	StopFlameThrowerVfx();
	SetFlameThrowerRange(range);
	pass
	
func _process(delta: float) -> void:
	if(!IsShooting):
		var enemy = get_target();
		if(enemy):
			targettedEnemy = enemy;
			IsShooting = true;
			PlayFlameThrowerVfx(enemy);
	elif(targettedEnemy == null):
		IsShooting = false;
		StopFlameThrowerVfx();
	pass
	
func PlayFlameThrowerVfx(enemy : Node2D) -> void:
	#Rotate properly
	var vector = (enemy.global_position - player.global_position).normalized();
	var upVector = Vector2(1,0);
	var rotAngle = vector.dot(upVector);
	ftParticles.rotation = acos(rotAngle);
	ftParticles.emitting = true;
	pass
	
func StopFlameThrowerVfx() -> void:
	ftParticles.emitting = false;
	pass
	
#adjust the flamethrower vfx visuals based on range
func SetFlameThrowerRange(range : float) -> void:
	pass
	
func apply_level_up():
	if(level == 5):
		ftParticles.process_material.scale *= 2.0
		damage *= 1.5
		return
	if(level == 10):
		ftParticles.scale += Vector2(1.0,1.0);
		ftParticles.amount += 100;
		ftParticles.process_material.scale *= 1.2
		damage *= 2.0
		return
	
	match level % 5:
		1:
			damage *= 1.5
		2:
			ftParticles.scale += Vector2(0.5,0.5);
			ftParticles.amount += 75;
		3:
			damage *= 1.5
		4:
			ftParticles.scale += Vector2(0.5,0.5);
			ftParticles.amount += 75;
