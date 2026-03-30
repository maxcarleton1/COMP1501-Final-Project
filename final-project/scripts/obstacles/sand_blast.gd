extends Area2D

var PUSH_FORCE: int = 750
var to_player: Vector2

func spawn(pos: Vector2, towards: Vector2):
	# Place at given position and face towards given vector
	global_position = pos
	global_rotation = towards.angle()
	$SandParticles.emitting = true
	
	to_player = towards
	
	$Timer.start()
	
	await $Timer.timeout
	queue_free()

func _on_body_entered(body: Node2D):
	# Push away
	if body.is_in_group("Player"):
		if not body.falling:
			body.velocity += to_player * PUSH_FORCE
