extends BaseGun

class_name TrapLauncher

var trap_duration = 30

func get_custom_tooltip_text() -> String: #override this
	return "\nTrap duration: " + str(trap_duration) + " seconds"
