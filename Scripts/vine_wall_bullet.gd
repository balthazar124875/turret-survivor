extends Node2D

#TODO: Here the vinewall will damage enemies, animate etc, die etc
var hp : int;

func instantiateVineWall(hpx : int) -> void:
	hp = hpx;
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
