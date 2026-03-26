extends CharacterBody2D

var player: CharacterBody2D
var activated: bool = false
var SPEED: int = 200
var PUSH_FORCE: int = 200

func _ready() -> void:
	$Sprite2D.play("default")
	
	player = get_tree().get_first_node_in_group("Player")
	activated = true # Add hitboxes to each level to stop this
	$AnimationPlayer.play("hover")

func _physics_process(delta: float):
	if activated:
		if player.global_position.x > global_position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
		var to_player := player.global_position - global_position
		if to_player.length() < 350 and to_player.length() > 250: # Keep distance
			to_player = Vector2.ZERO
		elif to_player.length() <= 250:
			to_player *= -1
		
		to_player = to_player.normalized()
		
		velocity = to_player * SPEED
		
		move_and_slide()

# When in range, blast the player
func blast():
	# Particle effect
	
	# Push away
	var push_vector = player.global_position - global_position
	push_vector = push_vector.normalized() * PUSH_FORCE
	
	
