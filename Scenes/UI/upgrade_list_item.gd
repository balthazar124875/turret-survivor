class_name UpgradeListItem

var level: int
var sprite: Texture2D
var upgrade_name: String

static func create(level: int, sprite: Texture2D, upgrade_name: String) -> UpgradeListItem:
	var instance = UpgradeListItem.new()
	instance.level = level
	instance.sprite = sprite
	instance.upgrade_name = upgrade_name
	return instance
