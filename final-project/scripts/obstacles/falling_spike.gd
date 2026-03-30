extends Node2D

@export var speed = 160.0
var falling := false

func _physics_process(delta: float) -> void:
	if falling:
		position.y += speed * delta

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		falling = true
		
		# Fade out then die
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.5)
		await tween.finished
		queue_free()

func _on_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_hit_by_obstacle()
