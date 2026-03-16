#Can modify size in editor
extends Node2D

@export var trigger_size: Vector2 = Vector2(200, 268)
@export var speed = 160.0
var current_speed = 0.0

func _ready():
	$Trigger/CollisionShape2D.position = Vector2(0, trigger_size.y / 2)

func _physics_process(delta: float) -> void:
	if current_speed != 0:
		position.y += current_speed * delta

func _on_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Damage Detected")
		body.fall()
		queue_free()
	else:
		current_speed = 0.0
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fall()
		print("fall triggered")

func fall():
	current_speed = speed
	print("falling")
