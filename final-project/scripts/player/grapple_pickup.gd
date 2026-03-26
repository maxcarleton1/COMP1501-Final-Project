extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Allow player to do bombs
		body.unlock_grapple()
		
		# Play some animation/particle effect?

		# Finally, disappear
		queue_free()
