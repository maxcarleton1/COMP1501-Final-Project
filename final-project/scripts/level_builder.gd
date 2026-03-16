extends Node2D

@export var demo_area: Area
@onready var start_room := preload("res://scenes/rooms/start_room.tscn")
@onready var end_room := preload("res://scenes/rooms/end_room.tscn")

# Variable to help each area decide where to start generating
@onready var start_position: Vector2 = $StartPoint.global_position
var last_room_exit_position: Vector2

# Tile size = Screen size + a little extra for padding
# 1920x1080 -> 2000x1100

signal start_barrier

func _ready() -> void:
	generate_start_room()
	generate_area(demo_area, 3, start_position)
	generate_end_room()

func call_start_barrier():
	start_barrier.emit()

# Generates the start room as the bottom of the tower, from there on rooms are randomized
func generate_start_room():
	assert(start_room != null) # Need start room to begin building areas
	
	# Instantiate it and place it at StartPoint
	var start := start_room.instantiate()
	add_child(start)
	
	start.global_position = start_position
	start_position = start.get_exit_pos()
	
	start.start_barrier.connect(call_start_barrier) # Bubbles barrier signal up to main
	
# Generates the end room as the top of the tower
func generate_end_room():
	assert(end_room != null)
	
	# Instantiate it and place it at StartPoint
	var end := end_room.instantiate()
	add_child(end)
	
	end.global_position = last_room_exit_position - end.get_entry_pos()

# Generates the area given the tile set source and the number of rooms in the set
func generate_area(area: Area, num_rooms: int, build_from: Vector2):
	# Ensure we can generate as many as requested
	assert(num_rooms <= len(area.rooms))
	
	var possible_rooms := area.rooms.duplicate() # Shallow copy just for shuffling order
	
	# Global position of previous room's exit
	# Gets reset by each room, so the next room/area knows where to start generating
	last_room_exit_position = build_from 

	if area.random_order: # Only randomize if the area allows it
		possible_rooms.shuffle()
	
	for i in range(num_rooms):
		# Pick a random room from the possible_rooms
		# Weighted room choices? for more replayability?
		var room_data: RoomData = possible_rooms[i]
		
		# Instantiate the scene and add to parent (this)
		var room_instance = room_data.room_scene.instantiate()
		add_child(room_instance)
		
		var exits = room_instance.get_exits()
		var exit_marker = exits.pick_random()
		
		if i == 0: # First room generates on build_from
			room_instance.global_position = last_room_exit_position + exit_marker.global_position
			last_room_exit_position = exit_marker.global_position
			continue

		# Pick a random entry to connect to a random exit
		var entries = room_instance.get_entrances()
		var entry_marker = entries.pick_random()
		
		# Move it to the proper location
		var offset = last_room_exit_position + (room_instance.global_position - entry_marker.global_position)
		room_instance.global_position = offset
		
		last_room_exit_position = exit_marker.global_position
