extends Area2D

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Allow player to do bombs
		body.unlock_bomb()
		
		# Play some animation/particle effect?

		# Finally, disappear
		queue_free()
