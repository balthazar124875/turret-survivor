extends BaseGun

class_name VineWall

var vines : Array[VineBullet] = [];
static var rndVineIndices : Array[int] = []; #Each location a vine can spawn in has an idx, with this list we prevent vines from spawning on eachother
var spikedVines : bool = false;
var bigVineScaleAmount = 1.0;

var vineCurrMaxAmount = 5;
var vineHP = 2;
var vineAttackDmg = 0.5;
static var nrOfVines = 0;
const MAX_VINE_AMOUNT : int = 20;

func _ready() -> void:
	super()
	vines.resize(MAX_VINE_AMOUNT)
	for idx in range(MAX_VINE_AMOUNT):
		rndVineIndices.push_back(idx);
	charge = cooldown - 0.1 #Makes a vine spawn immidiately
	pass # Replace with function body.

func getRandomAvailableSlotForVine() -> int:
	rndVineIndices.shuffle();
	return rndVineIndices.pop_back();
	
#Put the vine idx back into the list, marking it as an empty slot.
static func registerVineDeath(deadVineIdx : int) -> void:
	rndVineIndices.push_back(deadVineIdx);
	nrOfVines -= 1;

func shoot_area(position: Vector2) -> void:
	if(nrOfVines >= vineCurrMaxAmount):
		return; #Don't spawn vines if nr of vines exceeded max amount
	var rndVineSpawnIdx = getRandomAvailableSlotForVine();
	position = get_empty_vine_pos(rndVineSpawnIdx);
	var vine = bullet.instantiate()
	add_child(vine)
	vine.global_position = position
	vine.instantiateVineWall(vineHP, vineAttackDmg, spikedVines, rndVineSpawnIdx)
	vine.scale *= bigVineScaleAmount;
	vines[rndVineSpawnIdx] = vine;
	nrOfVines += 1;

func get_empty_vine_pos(rndIdx : int) -> Vector2:
	var screenSize = get_viewport().get_visible_rect().size;
	var distance = 200.0;
	var angleStep = PI*2.0 / MAX_VINE_AMOUNT;
	var angle = angleStep * rndIdx;
	
	var position = Vector2(1 , 1);
	position = position.rotated(angle)
	position *= distance
	position += player.global_position
	return position

func get_target_area() -> Vector2: #defaults to getting closest
	return Vector2(0,0)

func ScaleAllVines() -> void:
	for vine in vines:
		if vine == null:
			continue;
		vine.scale *= bigVineScaleAmount;

#TODO: Higher levels will always immidiately spawn 5 vines, then slowly spawn the rest
func apply_level_up():
	if(level == 5):
			spikedVines = true
			cooldown *= 0.9;
			vineAttackDmg = 1;
			return
	if(level == 10):
			#TODO: Enough vines to spawn in a circle around player
			#TODO: 10% chance to spawn enhaned vines with 3x hp and atk damage?
			#(On max level, max hp will be 5 and max atk damage 2)
			vineCurrMaxAmount = MAX_VINE_AMOUNT;
			bigVineScaleAmount = 1.5;
			ScaleAllVines()
			return
	
	match level % 5:
		1:
			vineHP += 1
		2:
			#Increase vine max amount
			vineCurrMaxAmount += 3;
		3:
			vineHP += 1
		4:
			vineAttackDmg *= 1.5 #Vine attack damage becomes 2 at max level
			vineCurrMaxAmount += 3;
