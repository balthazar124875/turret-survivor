extends PassiveUpgrade

@export var extraDuration = 0.5

@export var procChance = 0.15
@export var luckScaling = 0.02

var active = false

var magicDamage = false

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
	
func _apply_effects(enemy: Enemy, bullet: Bullet):
	var rndNumber = randf_range(0.0, 1.0);
	if(rndNumber <= procChance * (1 + (player.luck * luckScaling))):
		bullet.life_time += extraDuration
		if(magicDamage):
			#make bullets do magic damage
			bullet.damage += 0.5

func apply_level_up():
	if(upgradeAmount == 10):
		magicDamage = true
		return
	
	match upgradeAmount % 1:
		0:
			extraDuration += 0.1
		1:
			procChance += 0.05
