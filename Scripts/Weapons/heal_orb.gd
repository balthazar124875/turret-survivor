extends BaseOrb

class_name HealOrb

@export var healVfx : PackedScene
var healVfxParticleEmitter : GPUParticles2D;
var isHealVfxPlaying : bool;
var healVfxInstance;

@export var heal_per_tick: float = 5.0

func _ready() -> void:
	type = OrbHandler.OrbTypes.HEAL;
	isHealVfxPlaying = false;
	healVfxInstance = healVfx.instantiate();
	add_child(healVfxInstance)
	healVfxInstance.global_position = global_position;
	healVfxParticleEmitter = healVfxInstance.get_node("GPUParticles2D");
	super()
	StopHealVfxEffect();
	pass

func _physics_process(delta):
	var collisionList = $Area2D.get_overlapping_bodies();
	if(collisionList.is_empty()):
		StopHealVfxEffect();
		pass
	for body in collisionList:
		if body is Enemy:
			PlayHealVfxEffect();

func HitEnemy(body) -> void:
	body.take_damage(damage_per_tick, source, GlobalEnums.DAMAGE_TYPES.MAGIC)
	player.heal_damage(heal_per_tick, source)

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
	healVfxParticleEmitter.scale *= 2.5; #Needs to be the same value as range pushed out
	healVfxParticleEmitter.amount = 12;
	pass
