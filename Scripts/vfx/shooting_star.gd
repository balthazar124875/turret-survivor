extends Area2D

@export var starSign : PackedScene;
@export var starExplosion : PackedScene;

var starSignInstance;
var shootingStarSpeed = 0.75;
var distanceFromGoal = 3.0;
var goalPos;
var damage = 15.0
var damage_max_health_percent = 20.0
var source = "Shooting Star"
@onready var player_damage_mult = get_node("/root/EmilScene/Player").damageMultiplier
@onready var player = get_node("/root/EmilScene/Player")

var random_damage_type;
var starColor;

func init(signPos : Vector2) -> void:
	starSignInstance = starSign.instantiate();
	get_tree().root.add_child(starSignInstance);
	starSignInstance.global_position = signPos;
	
	var rndIdx = randi_range(0, GlobalEnums.ELEMENTAL_DAMAGE_TYPES.size() - 1)
	random_damage_type = GlobalEnums.ELEMENTAL_DAMAGE_TYPES[rndIdx];
	starColor = GlobalEnums.ShootingStarDamageColor[random_damage_type];
	
	$GPUParticles2D.material.set_shader_parameter("SecondaryColor", starColor);
	$"GPUParticles2D/Static star".material.set_shader_parameter("SecondaryColor", starColor);
	starSignInstance.get_node("GPUParticles2D").material.set_shader_parameter("SecondaryColor", starColor);
	goalPos = signPos;
	
	var rng = RandomNumberGenerator.new()
	distanceFromGoal = distanceFromGoal + rng.randf_range(0.0, 1.0); #Add a small delay
	#The shooting star itself
	self.global_position = goalPos * distanceFromGoal;
	pass;

func CreateStarExplosion() -> void:
	var starExplInst = starExplosion.instantiate();
	get_tree().root.add_child(starExplInst);
	starExplInst.global_position = goalPos;
	starExplInst.get_node("GPUParticles2D").material.set_shader_parameter("SecondaryColor", starColor);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	distanceFromGoal = distanceFromGoal - delta * shootingStarSpeed;
	self.global_position = goalPos * distanceFromGoal;
	if(distanceFromGoal <= 1.0):
		distanceFromGoal = 1.0;
		damage_enemies_in_collider();
		CreateStarExplosion();
		starSignInstance.queue_free();
		queue_free();
	pass
	
func damage_enemies_in_collider():
	var enemies = []
	for body in get_overlapping_bodies():
		if body is Enemy:
			  
			if(random_damage_type == GlobalEnums.DAMAGE_TYPES.ICE):
				var slow = StatusEffect.new(GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN, 3, 1)
				var effects: Array[StatusEffect] = [slow]
				body.take_hit(player.get_player_damage(damage, random_damage_type) + damage_max_health_percent, source, random_damage_type, effects)
			else:
				body.take_hit(player.get_player_damage(damage, random_damage_type) + damage_max_health_percent, source, random_damage_type)
			
