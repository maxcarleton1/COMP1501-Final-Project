extends Node2D

signal player_contact

var started := false

func _physics_process(delta: float):
	# Rises up slowly based on difficulty level/other shit
	# Maybe eventually make work with a path2d?
	if started:
		if GlobalStats.current_difficulty == GlobalStats.difficulty.NORMAL:
			global_position.y -= delta * GlobalStats.barrier_speed # Negative is up
		else:
			global_position.y -= delta

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		print("Lose") # Player loses, falls back to the start
		player_contact.emit()
		started = false # Stop movement
