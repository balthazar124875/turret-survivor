extends AugmentUpgrade

@export var shootingStarVfx : PackedScene;

var enemyKillCounter : int;
var killThreshold = 10;

func _ready() -> void:
	enemyKillCounter = 0;
	SignalBus.enemy_killed.connect(on_enemy_killed)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SpawnShootingStar(landingPos : Vector2) -> void:
	var shootingStar = shootingStarVfx.instantiate();
	get_tree().root.add_child(shootingStar);
	shootingStar.init(landingPos);
	pass

func on_enemy_killed(enemy: Enemy):
	enemyKillCounter += 1;
	if enemyKillCounter >= killThreshold:
		enemyKillCounter = 0;
		SpawnShootingStar(enemy.global_position);
