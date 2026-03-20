extends Node2D

signal start_run
signal hit_bottom

func get_exit_pos() -> Vector2:
	return $Exit.global_position

func _on_stop_fall_body_entered(body: Node2D):
	# Once the player falls this far, stop them from falling any more and return control
	if body.is_in_group("Player"):
		# Call reset in main
		hit_bottom.emit()
		
		# Important that this is called AFTER hit bottom, so the levels can be reset properly
		body.stop_fall()
		
		# Reenable lose barrier start hitbox
		$StartBarrier/CollisionShape2D.set_deferred("disabled", false)

func _on_start_barrier_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Calls barrier to start, anything else?
		start_run.emit()
	
		# Disable hitbox until lose barrier resets
		$StartBarrier/CollisionShape2D.set_deferred("disabled", true)
