extends Area2D

@export var Slow_Scalar :=0.5
var players := []

func _physics_process(delta: float) -> void:
	for p in players:
		if p:
			p.velocity *= Slow_Scalar

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not body.falling:
			print("In slow zone.")
			players.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not body.falling:
			print("Left slow zone.")
			players.erase(body)
