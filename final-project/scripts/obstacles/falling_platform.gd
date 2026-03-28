extends AnimatableBody2D

var falling := false
var original_pos := Vector2(0,0)
func _ready() -> void:
	original_pos= global_position
func _on_timer_timeout() -> void:
	falling = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 100, 2.5)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	respawnPlatform()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):	
		$Timer.stop()
		$Timer.wait_time = .5
func respawnPlatform():
	$CollisionShape.disabled = true

	await get_tree().create_timer(3.0).timeout

	$CollisionShape.disabled = false
	global_position = original_pos
	await get_tree().create_timer(.1).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
