extends Camera2D

var shake_intensity = 0
var shake_decay = 0.9  # How quickly the shake decays
var shake_offset = Vector2()

func _process(delta):
	if shake_intensity > 0.01:
		shake_offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_intensity
		offset = shake_offset  # Camera2D offset
		shake_intensity *= shake_decay  # Decay the shake
	else:
		offset = Vector2.ZERO  # Reset shake

func start_shake(intensity):
	shake_intensity = intensity
