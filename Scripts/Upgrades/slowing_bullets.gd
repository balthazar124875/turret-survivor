extends PassiveUpgrade

@export var slowAmount = 0.5 #10%
@export var duration = 2 #10%

@export var procChance = 0.1
@export var luckScaling = 0.02

var active = false

var coldDamge = false

@onready var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	self.player = player
	if(!active):
		SignalBus.on_enemy_hit.connect(_apply_effects)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _apply_effects(enemy: Enemy):
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance + (player.luck * luckScaling)):
		var slow = EnemyStatusEffect.new()
		slow.type = GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED
		slow.duration = duration
		slow.magnitude = slowAmount
		enemy.apply_status_effect(slow)

func apply_level_up():
	if(upgradeAmount == 10):
		var coldDamge = true
		#change damage type to cold
		return
	
	match upgradeAmount % 3:
		0:
			slowAmount += 0.1
		1:
			procChance += 0.05
		2:
			duration += 0.25
