extends Resource
class_name RoomData

# Resource which keeps track of any data each room will store
@export var room_scene: PackedScene
@export var room_size: Vector2i # In pixels?
@export var room_name: String
@export var weight: int = 1 # In case we want rarer rooms (weighted probabilities)
