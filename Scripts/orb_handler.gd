extends Node

class_name OrbHandler

enum OrbTypes
{
	FIRE,
	ICE,
	HEAL,
	LASER,
	GOLD,
	BLACK,
	COUNT
}
static var orbNames = ["Fire", "Ice", "Heal", "Laser", "Gold", "Black"]; #Keep in line with enum

static var playerOrbs : Array[BaseOrb] = [];
static var playerOrbsOuter : Array[BaseOrb] = [];
static var maxNrInnerOrbs : int;
static var maxNrOuterOrbs : int;
static var orbInventory : Array[OrbTypes];
#Each orbType gets enhanced after you own 5 of them
static var enhancedOrbs : Array[bool];
static var NR_ORBS_REQUIRED_FOR_ENHANCE : int = 5;

static var nextReplacableOrbIdx : int;
var player : Node2D;

#Orb stats, send these in when orbs level up
static var damagePerTick : int = 1;
static var effectMultiplier : float = 1.0;
static var orbSizeMultiplier : float = 1.0;
static var damageTickInterval : float = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent(); #Gets the parent which is Player
	maxNrInnerOrbs = 3;
	maxNrOuterOrbs = 1;
	nextReplacableOrbIdx = 0;
	
	orbInventory.resize(OrbTypes.COUNT);
	orbInventory.fill(0);
	
	enhancedOrbs.resize(OrbTypes.COUNT);
	enhancedOrbs.fill(false);
		
	pass

static func LevelUpOrbs(upgradeAmount : int) -> void:
	if(upgradeAmount == 5):
		damageTickInterval *= 1.0;
		orbSizeMultiplier *= 1.2;
		damagePerTick += 1;
	if(upgradeAmount == 10):
		effectMultiplier *= 2.0;
		orbSizeMultiplier *= 1.5;
		damageTickInterval *= 0.5;
		damagePerTick *= 2.0;
	match upgradeAmount % 5:
		1:
			damagePerTick += 1;
		2:
			damagePerTick += 1;
		3:
			effectMultiplier *= 1.2;
		4:
			damagePerTick += 1;
	ApplyStatsToOrbs()

#Loop through all your orbs and apply these stats to it
static func ApplyStatsToOrbs() -> void:
	var orbList = playerOrbs + playerOrbsOuter;
	for orb in orbList:
		ApplyStatsToOneOrb(orb)
		
	for orb in playerOrbsOuter:
		orb.ApplyVisualChanges() #Give outer orb the correct size
	pass
	
static func ApplyStatsToOneOrb(orb : BaseOrb) -> void:
	orb.ApplyOrbStats(damagePerTick, damageTickInterval, effectMultiplier, orbSizeMultiplier);
	pass

static func addPlayerBaseOrb(newOrb : BaseOrb):
	if(playerOrbs.size() < maxNrInnerOrbs):
		playerOrbs.push_back(newOrb);
		orbInventory[newOrb.type] += 1;
		SignalBus.orb_amount_increased.emit();
		#Re-arrange them all in a circle
		ArrangePlayerOrbs(playerOrbs);
	else:
		var orbList = playerOrbs;
		if (orbList.size() != 0):
			#Replace the next orb in the list
			var replacedOrb = orbList[nextReplacableOrbIdx];
			newOrb.global_position = replacedOrb.global_position;
			newOrb.currAngle = replacedOrb.currAngle;
			orbList[nextReplacableOrbIdx] = newOrb;
			replacedOrb.queue_free();
			nextReplacableOrbIdx += 1;
			nextReplacableOrbIdx = nextReplacableOrbIdx % orbList.size();
			orbInventory[replacedOrb.type] -= 1;
			orbInventory[newOrb.type] += 1;
	
	ApplyStatsToOneOrb(newOrb);
	
	#Check if you own more than 5 of the same orb, then enhance
	if orbInventory[newOrb.type] >= NR_ORBS_REQUIRED_FOR_ENHANCE:
		var wasThisOrbTypeEnhanced : bool = enhancedOrbs[newOrb.type];
		enhancedOrbs[newOrb.type] = true;
		if !wasThisOrbTypeEnhanced:
			for orb in playerOrbs: #Enhance all orbs of that type now
				if orb.type == newOrb.type:
					orb.EnhanceOrb();
			for orb in playerOrbsOuter: #Enhance all orbs of that type now
				if orb.type == newOrb.type:
					orb.EnhanceOrb();

static func ArrangePlayerOrbs(orbListToArrange : Array):
	if(orbListToArrange.size() == 0):
		return
	var nrOfOrbs = orbListToArrange.size();
	var angle = (360.0 / nrOfOrbs);
	var i = 0;
	angle = deg_to_rad(angle);
	for x in orbListToArrange:
		x.nextAngle = angle*i;
		var orbPos = Vector2(sin(x.nextAngle), cos(x.nextAngle))*x.orbRange;
		x.nextPos = orbPos;
		x.currAngle = (orbListToArrange[0].currAngle) + angle*i;
		i += 1;
	
	SignalBus.orb_total_increased.emit(playerOrbs.size(), maxNrInnerOrbs, playerOrbsOuter.size(), maxNrOuterOrbs)
