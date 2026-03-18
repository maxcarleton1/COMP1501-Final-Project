extends Node2D

@export var jump_height: float = 500.0  # pixels

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body is CharacterBody2D:
		if body.falling == false:
			var jump_velocity = -sqrt(2 * 980.0 * jump_height)
			var v = body.velocity
			v.y = jump_velocity
			body.velocity = v
			animate()
			print("Jump pad activated, velocity: ", jump_velocity)

func animate() ->void:
	$AnimatedSprite2D.set_frame(1)
	await get_tree().create_timer(0.8).timeout
	$AnimatedSprite2D.set_frame(0)
