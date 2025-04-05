extends Node

class_name OrbHandler

static var playerOrbs : Array[BaseOrb] = [];
static var playerOrbsOuter : Array[BaseOrb] = [];
static var maxNrInnerOrbs : int;
static var maxNrOuterOrbs : int;

static var nextReplacableOrbIdx : int;
var player : Node2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent(); #Gets the parent which is Player
	maxNrInnerOrbs = 3;
	maxNrOuterOrbs = 1;
	nextReplacableOrbIdx = 0;
	pass

static func addPlayerBaseOrb(newOrb : BaseOrb):
	if(playerOrbs.size() < maxNrInnerOrbs):
		playerOrbs.push_back(newOrb);
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

static func ArrangePlayerOrbs(playerOrbs : Array):
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
	
	SignalBus.orb_amount_increased.emit(playerOrbs.size(), maxNrInnerOrbs, playerOrbsOuter.size(), maxNrOuterOrbs)
