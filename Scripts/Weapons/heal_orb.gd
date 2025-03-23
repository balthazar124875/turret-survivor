extends BaseOrb

class_name HealOrb

@export var healVfx : PackedScene
var healVfxParticleEmitter : GPUParticles2D;
var isHealVfxPlaying : bool;
var healVfxInstance;
var tween : Tween

func _ready() -> void:
	super()
	tween = get_tree().create_tween();
	isHealVfxPlaying = false;
	healVfxInstance = healVfx.instantiate();
	add_child(healVfxInstance)
	healVfxInstance.global_position = global_position;
	healVfxParticleEmitter = healVfxInstance.get_node("GPUParticles2D");
	StopHealVfxEffect();
	pass

func _physics_process(delta):
	var collisionList = $Area2D.get_overlapping_bodies();
	if(collisionList.is_empty()):
		StopHealVfxEffect();
		pass
	for body in collisionList:
		if body is Enemy:
			HitEnemy(body, delta);

func HitEnemy(body, delta) -> void:
	PlayHealVfxEffect();
	body.take_damage(damage_per_tick * delta * player.damageMultiplier)
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if(isHealVfxPlaying):
		healVfxParticleEmitter.emitting = true;
		AdjustHealVfxLine();
		pass

func AdjustHealVfxLine() -> void:
	var point_A = global_position; #orb position
	var point_B = player.global_position;
	healVfxInstance.global_position = point_A;
	#Adjust the healvfx direction to move towards player
	var direction = Vector2(point_A - point_B).normalized();
	healVfxParticleEmitter.rotation = direction.angle() - PI;
	
func PlayHealVfxEffect() -> void:
	#Rotate properly
	isHealVfxPlaying = true;
	pass
	
func StopHealVfxEffect() -> void:
	healVfxParticleEmitter.emitting = false;
	isHealVfxPlaying = false;
	pass

#This will basically fixup the vfx effect when orb gets pushed out
func ApplyVisualChanges() -> void:
	super();
	healVfxParticleEmitter.scale *= 2.5;
	healVfxParticleEmitter.amount = 12;
	pass
	
	
