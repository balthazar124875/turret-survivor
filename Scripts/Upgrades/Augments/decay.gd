extends AugmentUpgrade

var enemy_parent: Node = null
var spreadRange: float = 400
var poison_duration: float = 5

@export var spreadVfx : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_parent = get_node("/root/EmilScene/Enemies")
	pass # Replace with function body.

func ApplyEnemyOnKillPassive(killedEnemy : Enemy) ->void:
	var enemyPoisonStacks = killedEnemy.get_status(GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED)
	if(enemyPoisonStacks.size() > 0):
		var closest_enemy: Enemy = null
		var shortest_distance: float = INF
		for enemy in enemy_parent.get_children():
			if enemy.is_inside_tree() && enemy.is_alive():
				var distance = killedEnemy.global_position.distance_to(enemy.global_position)
				if distance < shortest_distance && (distance < spreadRange * player.rangeMultiplier):
					shortest_distance = distance
					closest_enemy = enemy
					
		if(closest_enemy != null):
			var poisonEffect = EnemyStatusEffect.new()
			poisonEffect.type = GlobalEnums.ENEMY_STATUS_EFFECTS.POISONED
			poisonEffect.duration = poison_duration
			poisonEffect.magnitude = enemyPoisonStacks.reduce(func(a, b): return a + b.magnitude  * 3 / b.duration, 0)
			closest_enemy.apply_status_effect(poisonEffect)
			
			var newLine = spreadVfx.instantiate();
			newLine.add_point(closest_enemy.global_position - player.global_position)
			newLine.add_point(killedEnemy.global_position - player.global_position)
			player.add_child(newLine)
			
func get_description() -> String:
	return "Enemies who die while poisoned transfer remaining poison to nearby ally within [color=yellow]" + str(spreadRange * player.rangeMultiplier) + "[/color] range"
