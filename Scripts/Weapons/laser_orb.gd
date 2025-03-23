extends BaseOrb

class_name LaserOrb

@export var laserVfx : PackedScene
var laserVfxParticleEmitter : GPUParticles2D;
var laserVfxInstance;
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	laserVfxInstance = laserVfx.instantiate();
	add_child(laserVfxInstance)
	laserVfxInstance.global_position = global_position;
	laserVfxParticleEmitter = laserVfxInstance.get_node("GPUParticles2D");
	StartLaserVfx();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	pass

func StartLaserVfx() -> void:
	laserVfxParticleEmitter.emitting = true;
	pass
