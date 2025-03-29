extends Area2D

class_name Trap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body is Enemy:  # Replace with your enemy script class name
		trigger_trap()

func trigger_trap():
	pass
