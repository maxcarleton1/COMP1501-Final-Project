extends Node2D

var started := false

func _physics_process(delta: float):
	# Rises up slowly based on difficulty level/other shit
	# Maybe eventually make work with a path2d?
	if started:
		if GlobalStats.current_difficulty == GlobalStats.difficulty.NORMAL: # This is whatever, if we even do difficulty
			global_position.y -= delta * GlobalStats.barrier_speed # Negative is upwards
		else:
			global_position.y -= delta

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Player loses, falls back to the start
		body.get_hit_by_obstacle()
		started = false # Stop movement

func start_moving():
	# Starts barrier movement
	started = true
	
func reset(pos: Vector2):
	# Resets position, should implement some animation or something so this doesn't look like it's teleporting
	global_position = pos
	started = false
