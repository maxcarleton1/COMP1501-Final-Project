extends Node2D

@export var test_area: AreaSet

# Tile size = Screen size + a little extra for padding
# 1920x1080 -> 2000x1100

func _ready() -> void:
	generate_area(test_area, 3)

# Generates the area given the tile set source and the number of rooms in the set
func generate_area(area_set: AreaSet, num_rooms: int):
	# Ensure we can generate as many as requested
	assert(num_rooms <= len(area_set.rooms))
	
	var possible_rooms := area_set.rooms.duplicate() # Shallow copy just for shuffling order
	var last_room_exit_position: Vector2 = $StartPoint.global_position # For setting positions
	
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
		
		if i == 0: # First room generates on StartPoint
			room_instance.global_position = last_room_exit_position
			last_room_exit_position = exit_marker.global_position
			continue

		# Pick a random entry to connect to a random exit
		var entries = room_instance.get_entrances()
		var entry_marker = entries.pick_random()
		
		# Move it to the proper location
		var offset = last_room_exit_position + (room_instance.global_position - entry_marker.global_position)
		room_instance.global_position = offset
		
		last_room_exit_position = exit_marker.global_position
