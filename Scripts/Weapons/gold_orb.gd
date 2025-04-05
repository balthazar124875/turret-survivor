extends BaseOrb

class_name GoldOrb

@export var goldVfx : PackedScene
var goldVfxParticleEmitter : GPUParticles2D;
var isGoldVfxPlaying : bool;
var goldVfxInstance;

@export var gold_per_tick: float = 1.0

func _ready() -> void:
	super()
	isGoldVfxPlaying = false;
	goldVfxInstance = goldVfx.instantiate();
	add_child(goldVfxInstance)
	goldVfxInstance.global_position = global_position;
	goldVfxParticleEmitter = goldVfxInstance.get_node("GPUParticles2D");
	StopGoldVfxEffect();
	pass

func _physics_process(delta):
	var collisionList = $Area2D.get_overlapping_bodies();
	if(collisionList.is_empty()):
		StopGoldVfxEffect();
		pass
	for body in collisionList:
		if body is Enemy:
			PlayGoldVfxEffect();

func HitEnemy(body) -> void:
	player.modify_gold(gold_per_tick)
	#super.HitEnemy(body, delta) #This orb does no damage to enemies

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if(isGoldVfxPlaying):
		goldVfxParticleEmitter.emitting = true;
		AdjustGoldVfxLine();
		pass

func AdjustGoldVfxLine() -> void:
	var point_A = global_position; #orb position
	var point_B = player.global_position;
	goldVfxInstance.global_position = point_A;
	#Adjust the goldvfx direction to move towards player
	var direction = Vector2(point_A - point_B).normalized();
	goldVfxParticleEmitter.rotation = direction.angle() - PI;
	
func PlayGoldVfxEffect() -> void:
	#Rotate properly
	isGoldVfxPlaying = true;
	pass
	
func StopGoldVfxEffect() -> void:
	goldVfxParticleEmitter.emitting = false;
	isGoldVfxPlaying = false;
	pass

#This will basically fixup the vfx effect when orb gets pushed out
func ApplyVisualChanges() -> void:
	super();
	goldVfxParticleEmitter.scale *= 2.5; #Needs to be the same value as range pushed out
	goldVfxParticleEmitter.amount = 12;
	pass
	
	
