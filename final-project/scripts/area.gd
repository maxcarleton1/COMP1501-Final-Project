extends Resource
class_name Area

# A simple class which stores all the rooms in a given area.
@export var rooms: Array[RoomData]
@export var random_order: bool # Whether rooms are in random order or not

# If not in random order, it will generate in the array order givend

# Could implement room pools based on difficulty here or in AreaSet
