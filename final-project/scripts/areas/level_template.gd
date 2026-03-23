extends Node2D

# This template should not be used in the actual game
# To make a new room:
# 1. Right click this scene in the filesystem and duplicate this scene
# 2. Edit however you want (but make sure you set the entry/exit points correctly)
# 3. Create a new RoomData resource in the resources folder
# 4. Drag and drop the new scene into the new resource (in the inspector) and set the properties
# 5. Add the scene to the Area
# 6. Add Area to AreaSet if needed

# "Interface" script, ie template must contain at minimum these nodes
func _ready():
	if not has_node("Entries"):
		push_error("Missing required child node: Entries")
	if not has_node("Exits"):
		push_error("Missing required child node: Exits")

func get_entrances() -> Array:
	return $Entries.get_children()

func get_exits() -> Array:
	return $Exits.get_children()
