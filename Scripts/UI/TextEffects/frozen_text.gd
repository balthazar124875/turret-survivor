@tool
extends RichTextEffect
class_name FrozenEffect

var bbcode = "frozen"

var elapsed_time := 0.0

var _word = 0.0

func _process_custom_fx(char_fx):
	var t = smoothstep(0.3, 0.6, sin(char_fx.elapsed_time * 4.0) * .5 + .5)
	char_fx.color = lerp(Color.DARK_TURQUOISE, Color.CYAN, t)
	
	if char_fx.relative_index == 0:
		_word = 0
	
	var scale:float = char_fx.env.get("scale", 1.0)
	var freq:float = char_fx.env.get("freq", 8.0)
	
	#var s = fmod((_word + char_fx.elapsed_time) * PI * 1.25, PI * 2.0)
	#var p = sin(char_fx.elapsed_time * freq)
	#char_fx.offset.x += sin(s) * p * scale
	#char_fx.offset.y += cos(s) * p * scale
	return true
