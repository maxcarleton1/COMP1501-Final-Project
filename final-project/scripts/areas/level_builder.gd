extends Node2D

@onready var temp_area_set := preload("res://scenes/areas/testing_area_set.tres")
@onready var start_room_scene := preload("res://scenes/areas/common/start_room.tscn")
@onready var end_room_scene := preload("res://scenes/areas/common/end_room.tscn")

# So we don't rebuild these
var start_room: Node2D
var end_room: Node2D

# Variable to help each area decide where to start generating
@onready var start_position: Vector2 = $StartPoint.global_position
var last_room_exit_position: Vector2

# Tile size = Screen size + a little extra for padding
# 1920x1080 -> 2000x1100

func _ready():
	generate_area_set(temp_area_set)

func generate_area_set(area_set: AreaSet):
	generate_start_room()
	
	for area in area_set.areas: # Generate each area individually
		var temp: Array[Node2D]
		if area.num_to_generate == -1:
			temp = generate_area(area, start_position) # num_rooms is optional
		else:
			temp = generate_area(area, start_position, area.num_to_generate) # num_rooms is optional
		call_deferred("add_children", temp)
	
	generate_end_room()

# Generates the start room as the bottom of the tower, from there on rooms are randomized
func generate_start_room():
	assert(start_room_scene != null) # Need start room to begin building areas
	
	# Instantiate it and place it at StartPoint
	start_room = start_room_scene.instantiate()
	add_child(start_room)
	
	start_room.global_position = start_position
	start_position = start_room.get_exit_pos()
	
# Generates the end room as the top of the tower
func generate_end_room():
	assert(end_room_scene != null)
	
	# Instantiate it and place it at StartPoint
	end_room = end_room_scene.instantiate()
	add_child(end_room)
	
	end_room.global_position = last_room_exit_position - end_room.get_entry_pos()

func get_weighted_probabilities(rooms: Array[RoomData]) -> RoomData:
	var total_weight := 0.0

	for room_data in rooms: # Sum all room weights
		total_weight += room_data.weight

	var r := randf() * total_weight # Random number between 0 and total_weight
	var running := 0.0

	# Pick a random point along the probability "bar", and whatever room is on that space gets picked
	# Room pick chance is proportional to its weight
	for room_data in rooms:
		running += room_data.weight
		if r <= running:
			return room_data

	return rooms.back() # Fallback, returns the last room in the area

# Generates the area given the tile set source and the number of rooms in the set
func generate_area(area: Area, build_from: Vector2, num_rooms: int = -1) -> Array[Node2D]:
	# If num_rooms is not set, build all rooms in the area
	if num_rooms != -1:
		# Ensure we can generate as many as requested
		assert(num_rooms <= len(area.rooms))
	else:
		num_rooms = area.rooms.size()
		
	var use_weighted: bool
	if area.random_order and area.use_weighted:
		use_weighted = false # Overwrite because we can't have both
	elif area.use_weighted:
		use_weighted = true
	else:
		use_weighted = false
	
	var possible_rooms := area.rooms.duplicate() # Shallow copy just for shuffling order
	
	# Global position of previous room's exit
	# Gets reset by each room, so the next room/area knows where to start generating
	last_room_exit_position = build_from 

	# Only randomize if the area allows it + if we're not using weighted probabilities
	if area.random_order and not use_weighted: 
		possible_rooms.shuffle()
		
	var temp_array: Array[Node2D] = []
	
	for i in range(num_rooms): # Pick a random room from the possible_rooms
		var room_data: RoomData

		if use_weighted:
			room_data = get_weighted_probabilities(possible_rooms)
		else:
			room_data = possible_rooms[i]
		
		# Instantiate the scene and add to parent (this)
		var room_instance = room_data.room_scene.instantiate()
		
		# Add to temp array so we can add_child deferred after
		temp_array.append(room_instance)
		
		# Pick entry + exit FIRST
		var entries = room_instance.get_entrances()
		var entry_marker = entries.pick_random()

		var exits = room_instance.get_exits()
		var exit_marker = exits.pick_random()

		# Align this room's entry to the previous room's exit
		room_instance.global_position += last_room_exit_position - entry_marker.global_position

		# Now that the room has been moved, update the exit position correctly
		last_room_exit_position = exit_marker.global_position

		# If this is the last room, update the next area's start
		if i == num_rooms - 1:
			start_position = last_room_exit_position
		
	return temp_array

# Call deferred because doing it during physics process is bad
func add_children(rooms: Array[Node2D]):
	for room in rooms:
		add_child(room)
		
	# Move end room to proper position
	end_room.global_position = last_room_exit_position - end_room.get_entry_pos_difference()

# Currently just deletes all rooms besides the start and rebuilds them, might want to change later
# Called by main upon hitting the bottom
func regenerate():	
	# Reset generation positions
	start_position = start_room.get_exit_pos()
	
	# Delete old rooms
	for room in get_children():
		if room != start_room and room != end_room:
			room.queue_free()
	
	# Rebuild
	for area in temp_area_set.areas: # Generate each area individually
		var temp := generate_area(area, start_position) # num_rooms is optional
		call_deferred("add_children", temp)
