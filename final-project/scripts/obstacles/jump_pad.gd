extends Node2D

@export var jump_height: float = 500.0  # pixels

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not body.falling:
			$Bounce.play()
			var jump_velocity = -sqrt(2 * 980.0 * jump_height)
			body.velocity.y = jump_velocity
			animate()

func animate() -> void:
	$AnimatedSprite2D.set_frame(1)
	await get_tree().create_timer(0.8).timeout
	$AnimatedSprite2D.set_frame(0)
