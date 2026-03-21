extends Area2D

@export var Slow_Modify := 2  # A value of 2 half the player speed
var slow_scalar :=0.5

func _ready() -> void:
	slow_scalar = 1/Slow_Modify

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not body.falling:
			print("In slow zone.")
			body.velocity = slow_scalar * body.velocity

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not body.falling:
			print("Left slow zone.")
			body.velocity = Slow_Modify * body.velocity
