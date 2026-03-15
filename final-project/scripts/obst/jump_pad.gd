extends Node2D

@export var jump_height: float = 300.0  # pixels

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body is CharacterBody2D:
		var jump_velocity = -sqrt(2 * 980.0 * jump_height)
		var v = body.velocity
		v.y = jump_velocity
		body.velocity = v
		print("Jump pad activated, velocity: ", jump_velocity)
