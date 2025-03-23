extends BaseOrb

class_name LaserOrb

@export var laserVfx : PackedScene
var laserVfxParticleEmitter : GPUParticles2D;
var laserLineNode :Line2D;
var laserVfxInstance;
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	laserVfxInstance = laserVfx.instantiate();
	add_child(laserVfxInstance)
	laserVfxInstance.global_position = global_position;
	laserVfxParticleEmitter = laserVfxInstance.get_node("GPUParticles2D");
	laserLineNode = laserVfxInstance.get_node("Line2D");
	StartLaserVfx();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	var enemy = get_target() #Gets closest enemy #TODO: Get strongest instead
	if(enemy != null):
		laserLineNode.points[1] = to_local(enemy.global_position);
		var line_length = laserLineNode.points[0].distance_to(laserLineNode.points[1]);
		laserVfxParticleEmitter.process_material.emission_box_extents = Vector3(line_length/2.0, 1, 1);
		laserVfxParticleEmitter.process_material.emission_shape_offset = Vector3(line_length/2, 0, 0)
		#Rotate the particle2D effect to fit the line rotation
		#laserVfxParticleEmitter.scale = Vector2(line_length, line_length);
		var rotAngle = (laserLineNode.points[0] - laserLineNode.points[1]).angle();
		laserVfxParticleEmitter.rotation = rotAngle - PI;
		StartLaserVfx();
	else:
		ShutDownLaserVfx();
	pass

func StartLaserVfx() -> void:
	laserVfxParticleEmitter.emitting = true;
	laserLineNode.visible = true;
	pass
	
func ShutDownLaserVfx() -> void:
	laserVfxParticleEmitter.emitting = false;
	laserLineNode.visible = false;
	pass
