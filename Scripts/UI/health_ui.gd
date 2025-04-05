extends Control

@onready var health_label = $HealthLabel
@onready var armor_label = $ArmorLabel
@onready var health_bar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_health_updated.connect(update_health)
	SignalBus.armor_updated.connect(update_armor)


func update_health(newValue: float, maxHealth: float) -> void:
	health_label.text = str("HP: ", str(int(newValue)), "/", str(int(maxHealth)))
	health_bar.value = newValue
	health_bar.max_value = maxHealth

func update_armor(newValue: float, source: String) -> void:
	armor_label.text = str("Armor: ", str(int(newValue)))
