extends Node

@onready var player := get_parent() as CharacterBody2D
@onready var animated_sprite := player.get_node("AnimatedSprite2D") 

func _physics_process(_delta: float) -> void:
	var horizontal_speed := player.velocity.x
	#Flips the sprite
	if horizontal_speed > 0:
		animated_sprite.flip_h = true
	elif horizontal_speed < 0:
		animated_sprite.flip_h = false

	var target_animation := "Idle"
	if not player.is_on_floor() and not player.falling:
		target_animation = "Jump"
	elif abs(horizontal_speed) > 0 and not player.falling:
		target_animation = "Running"

	if animated_sprite.animation != target_animation:
		animated_sprite.play(target_animation)
