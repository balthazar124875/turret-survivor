extends Node

class_name UnlockNode

enum UnlockType
{
	PLAYER,
	UPGRADE #Includes augments and everything, these are basically our achievements.
}

var isLocked = true;
var description = "";
#We will iterate this list in the beginning of the game for all UnlockNodes,
#and set the flag isLocked to true for all Augments/upgrades/players etc that
#are in this list.
@export var lockedItems : Array[PackedScene];
@export var unlockType : UnlockType;

func Init():
	if isLocked:
		subscribe_to_signals();
	
func UnlockThisNode():
	if isLocked:
		for item in lockedItems:
			#var itemName = item.instantiate().name; #inefficient to instantiate it, but not a big deal
			var itemName = item.resource_path.get_file().get_basename();
			UnlockHandler.lockedItemsDictionary[itemName] = true;
			
			#Run UI code that will notify the player and play some party vfx
			#You'll send in name and sprite icon into the UI function and that's it!
			var itemInstance = item.instantiate();
			itemInstance.init();
			var unlockName = "";
			if itemInstance is PlayerSelectNode:
				unlockName = itemInstance.playerName;
			elif itemInstance is Upgrade:
				unlockName = itemInstance.upgradeName;
			else:
				print("Unlocked item name not found! This is a bad error, investigate!")
			UnlockHandler.RenderAchievementBox(unlockName, itemInstance.unlockCondition, itemInstance.icon);
			UnlockHandler.save_data()
			print(unlockName + " unlocked!");
	isLocked = false;
	
func subscribe_to_signals():
	pass;
