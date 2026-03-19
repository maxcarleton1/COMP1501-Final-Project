extends Resource
class_name Area

# A simple class which stores all the rooms in a given area.
@export var rooms: Array[RoomData]
@export var random_order: bool # Whether rooms are in random order or not
@export var num_to_generate: int = -1 # Leave as -1 to generate all rooms in the area
@export var use_weighted: bool # Whether to use weighted probabilities for rooms, gets overwritten by random_order

# If not in random order, it will generate in the array order given

# Could implement room pools based on difficulty here or in AreaSet
