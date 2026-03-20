extends Node2D

@export var trigger_size: Vector2 = Vector2(200, 268)
@export var speed = 160.0
var current_speed = 0.0

@onready var trigger_area: Area2D = $Trigger
@onready var hitbox_area: Area2D = $Spike
@onready var trigger_shape: CollisionShape2D = $Trigger/CollisionShape2D

func _ready():
	var rect = trigger_shape.shape as RectangleShape2D
	rect.size = trigger_size
	trigger_shape.position = Vector2(0, trigger_size.y / 2)

func _physics_process(delta: float) -> void:
	if current_speed != 0:
		position.y += current_speed * delta

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_speed = speed

func _on_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_hit_by_obstacle()
		
		# Might want to call some animation or fade out here and remove on animation end?
		queue_free()
	else:
		current_speed = 0.0
		await get_tree().create_timer(0.5).timeout
		queue_free()
