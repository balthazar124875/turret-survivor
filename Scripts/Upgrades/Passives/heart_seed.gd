extends PassiveUpgrade

@export var health_regeneration = 1

@onready var player = get_node("/root/EmilScene/Player")

var timer: Timer

var growthOnKill
@export var timerBase = 40
@export var procChance = 0.1
@export var luckScaling = 0.05

var t = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	t += delta

func reparentToPlayer(player: Player) -> void:
	start_timer()
	player.get_node("./Upgrades/Passives").add_child(self)
	
func start_timer():
	timer = Timer.new()
	timer.wait_time = timerBase
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	
func _on_timer_timeout() -> void:
	print("incerasing regen by " + str(health_regeneration) + ", " + str(player.healthRegeneration) + ", took " + str(t) + " seconds")
	t = 0
	timer.stop()
	timer.wait_time = timerBase
	timer.start()
	player.modify_stat(GlobalEnums.PLAYER_STATS.ADD_HEALTH_REGENERATION, health_regeneration, upgradeName)
	
func _on_enemy_killed(enemy: Enemy) -> void:
	var r = randf_range(0, 1)
	if(r < procChance * (1 + (player.luck * luckScaling))):
		#timer.start(timer.time_left - 1)
		var time_left = timer.time_left
		var new_time = max(time_left - 1, 0.01)
		timer.stop()
		timer.wait_time = new_time
		timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#player.modify_health_regeneration(health_regeneration_per_second * delta)
	
func apply_level_up():
	if(upgradeAmount == 10):
			growthOnKill = true
			SignalBus.enemy_killed.connect(_on_enemy_killed)
			return
			
	else:
		health_regeneration += 0.5
