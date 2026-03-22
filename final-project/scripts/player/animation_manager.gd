extends Node

@export var move_threshold := 0.01

@onready var player := get_parent() as CharacterBody2D
@onready var animated_sprite := player.get_node("AnimatedSprite2D") 

func _physics_process(_delta: float) -> void:
	var is_falling_state := bool(player.get("falling"))
	var horizontal_speed := player.velocity.x
	#Flips the sprite
	if horizontal_speed < move_threshold:
		animated_sprite.flip_h = false
	elif horizontal_speed > -move_threshold:
		animated_sprite.flip_h = true

	var target_animation := "Idle"
	if not player.is_on_floor() and not is_falling_state:
		target_animation = "Jump"
	elif abs(horizontal_speed) > move_threshold and not is_falling_state:
		target_animation = "Running"

	if animated_sprite.animation != target_animation:
		animated_sprite.play(target_animation)
