extends Control

@export var white: Texture2D = load("res://Textures/Circle/blank_white.png")

func _ready() -> void:
	pass # Replace with function body.

func init(source: String):
	$"Source Name".text = "[color=black]" + source

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rerender(damage_types, total: float, sum: float) -> void:
	$Total.text = "[color=black]" + String.num(total, 0)
	
	var x: int = 0
	
	for d in damage_types.keys():
		var type = GlobalEnums.DAMAGE_TYPES.keys()[d]
		
		var type_obj = get_damage_child_by_name(type)
		if(type_obj != null):
			type_obj.position = Vector2(x, 0)
			var width = get_width(sum, damage_types[d])
			type_obj.size = Vector2(width, 30)
			x += width
		else:
			var text = TextureRect.new()
			text.texture = white
			text.modulate = damage_type_colors[d]
			
			#damage_list.add_child(label)
			text.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			text.name =  type
			
			text.position = Vector2(x, 0)
			var width = get_width(sum, damage_types[d])
			text.size = Vector2(width, 30)
			x += width
			
			$Types.add_child(text)
		
		
func get_width(total: float, value: float):
	if(total == 0):
		return 250
		
	var percentage = value/total
		
	return percentage * 250
		
func get_damage_child_by_name(child_name: String) -> Node:
	# Loop through all child nodes
	for child in $Types.get_children():
		if child.name == child_name:
			return child  # Return the child node if it matches the name
	
	# Return null if no child with that name is found
	return null

var damage_type_colors = {
	GlobalEnums.DAMAGE_TYPES.PHYSICAL: "white",
	GlobalEnums.DAMAGE_TYPES.MAGIC: "purple",
	GlobalEnums.DAMAGE_TYPES.ICE: "cyan",
	GlobalEnums.DAMAGE_TYPES.FIRE: "orange",
	GlobalEnums.DAMAGE_TYPES.POISON: "green",
	GlobalEnums.DAMAGE_TYPES.LIGHTNING: "yellow"
}
