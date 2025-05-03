extends PassiveUpgrade

@export var slowAmount = 0.5 #10%
@export var duration = 2 #10%

@export var procChance = 0.1
@export var luckScaling = 0.02

@export var color: Color
@export var colorPriority = 0


var active = false

var coldDamage = false

@onready var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func applyUpgradeToPlayer(player: Player) -> void:
	self.player = player
	if(!active):
		SignalBus.bullet_created.connect(_bullet_created)
		active = true
	super.applyUpgradeToPlayer(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _bullet_created(bullet):
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		bullet.effects.append(_apply_effects)
		bullet.get_node("Sprite2D").modulate = color
		if(coldDamage):
			bullet.damage_type = GlobalEnums.DAMAGE_TYPES.ICE
	
func _apply_effects(enemy: Enemy, bullet: Bullet):
	var slow = EnemyStatusEffect.new()
	slow.type = GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED
	slow.duration = duration
	slow.magnitude = slowAmount
	enemy.apply_status_effect(slow)

func apply_level_up():
	if(upgradeAmount == 10):
		coldDamage = true
		return
	
	match upgradeAmount % 3:
		0:
			slowAmount += 0.02
		1:
			procChance += 0.05
		2:
			duration += 0.25
