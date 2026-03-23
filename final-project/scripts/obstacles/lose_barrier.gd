extends Node2D

var started := false

func _physics_process(delta: float):
	# Rises up slowly based on difficulty level/other shit
	# Maybe eventually make work with a path2d?
	if started:
		global_position.y -= delta * GlobalStats.difficulty_data.barrier_speed # Negative is upwards

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Player loses, falls back to the start
		body.get_hit_by_obstacle()
		started = false # Stop movement

func start_moving():
	# Starts barrier movement
	started = true
	
func reset(pos: Vector2, smooth: bool):
	# Smoothly descend to the start point
	if not smooth:
		global_position = pos
	else:
		var tween = create_tween()
		tween.tween_property(self, "position:y", pos.y, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	started = false
