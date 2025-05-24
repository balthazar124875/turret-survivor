extends Node

enum PLAYER_STATS {
	ATTACK_SPEED,
	RANGE_MULTIPLER,
	DAMAGE_MULTIPLIER,
	PROJECTILE_SPEED_MULTIPLIER,
	EXTRA_PROJECTILES,
	EXTRA_CHAINS,
	ADD_MAX_HEALTH,
	ADD_HEALTH_REGENERATION,
	ADD_BASE_INCOME,
	MULTIPLY_INCOME_TIMER,
	AREA_SIZE_MULTIPLIER,
	BONUS_LUCK,
	ADD_ARMOR,
	BONUS_PIERCE,
	BONUS_BOUNCE,
	HEALING_MULTIPLIER
}

enum DAMAGE_TYPES {
	PHYSICAL,
	MAGIC,
	ICE,
	FIRE,
	POISON,
	LIGHTNING
}

#See damage_type_colors
var DamageColor = [
	Color(0.827, 0.827, 0.827),  # PHYSICAL - light gray
	Color(0.933, 0.51, 0.933),   # MAGIC - purple/violet
	Color(0.0, 1.0, 1.0),        # ICE - cyan
	Color(1.0, 0.647, 0.0),      # FIRE - orange
	Color(0.0, 1.0, 0.0),        # POISON - green
	Color(1.0, 1.0, 0.2)         # LIGHTNING - yellow
]

#More lighter/cuter colors for our shooting star
var ShootingStarDamageColor = [
	Color(0.827, 0.827, 0.827),       # PHYSICAL - light gray
	Color(0.9882, 0.6431, 0.7059),    # MAGIC - pink
	Color(0.0, 1.0, 1.0),             # ICE - cyan
	Color(0.968, 0.639, 0.027),       # FIRE - orange
	Color(0.3490, 1.0, 0.6745),       # POISON - spring green
	Color(1.0, 1.0, 0.2)              # LIGHTNING - yellow
]

enum ENEMY_CHAMPION_TYPE {
	NONE,
	SPLITTING,
	QUICK,
	REGENERATING,
	JUGGERNAUT,
	COUNT
}

enum ENEMY_STATUS_EFFECTS {
	FROZEN,
	SLOWED,
	ROOTED,
	POISONED,
	BURNING
}

static var CROWD_CONTROL = [
	GlobalEnums.ENEMY_STATUS_EFFECTS.FROZEN,
	GlobalEnums.ENEMY_STATUS_EFFECTS.SLOWED,
	GlobalEnums.ENEMY_STATUS_EFFECTS.ROOTED
	]
	
static var ELEMENTAL_DAMAGE_TYPES = [
	GlobalEnums.DAMAGE_TYPES.MAGIC,
	GlobalEnums.DAMAGE_TYPES.ICE,
	GlobalEnums.DAMAGE_TYPES.FIRE,
	GlobalEnums.DAMAGE_TYPES.POISON,
	GlobalEnums.DAMAGE_TYPES.LIGHTNING
]
