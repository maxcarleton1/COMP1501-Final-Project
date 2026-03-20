extends Resource
class_name RoomData

# The room scene itself, which gets loaded by level_builder
@export var room_scene: PackedScene
# Might be useful, might not
@export var room_name: String
# Weighted probabilities, only if use_weighted is true in level builder's generate_area()
@export var weight: float = 1.0 # Higher weight = more likely to be picked, and sooner
