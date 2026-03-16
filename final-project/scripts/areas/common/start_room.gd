extends Node2D

signal start_barrier

func get_exit_pos() -> Vector2:
	return $Exit.global_position

func _on_stop_fall_body_entered(body: Node2D):
	# Once the player falls this far, stop them from falling any more and return control
	if body.is_in_group("Player"):
		print("stopped")
		body.stop_fall()
		
		# Reenable lose barrier start hitbox
		$StartBarrier/CollisionShape2D.set_deferred("disabled", false)

func _on_start_barrier_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		print("started")
		start_barrier.emit() # Send signal to start barrier here, bubble it up to main? better way???
	
		# Disable hitbox until lose barrier resets
		$StartBarrier/CollisionShape2D.set_deferred("disabled", true)
