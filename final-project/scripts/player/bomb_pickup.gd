extends Area2D

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Allow player to do bombs
		body.unlock_bomb()
		
		$GPUParticles2D.emitting = true
		$Sprite2D.hide()

		# Finally, disappear after particle effect
		await $GPUParticles2D.finished
		queue_free()
