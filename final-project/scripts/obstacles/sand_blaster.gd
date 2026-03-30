extends CharacterBody2D

var player: CharacterBody2D
var activated: bool = false
var SPEED: int = 200
var can_blast := true
var stunned := false
var VISION_RANGE := 750

@onready var sand_scene: PackedScene = preload("res://scenes/obstacles/moving_obstacles/sand_blast.tscn")

func _ready() -> void:
	$BlastCooldown.wait_time = GlobalStats.difficulty_data.sand_blaster_cooldown
	$Sprite2D.play("default")
	
	player = get_tree().get_first_node_in_group("Player") # Janky, might want to do area vision instead
	$AnimationPlayer.play("hover")

func _physics_process(delta: float):
	var to_player := player.global_position - global_position
	
	# Deactivate when player falling
	if to_player.length() <= VISION_RANGE and not player.falling:
		activated = true
	else:
		activated = false
	
	if activated and not stunned:
		if player.global_position.x > global_position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
		if to_player.length() < 250 and to_player.length() > 200: # Keep distance
			to_player = Vector2.ZERO
			if can_blast:
				blast()
		elif to_player.length() <= 200:
			to_player *= -1
		
		to_player = to_player.normalized()
		
		velocity = to_player * SPEED
		
		move_and_slide()

# When in range, blast the player
func blast():
	# Spawn sandblast and stuff
	var sand = sand_scene.instantiate()
	get_parent().call_deferred("add_child", sand)
	
	var to_player := player.global_position - global_position
	to_player = to_player.normalized()

	sand.call_deferred("spawn", global_position, to_player)
	can_blast = false
	$BlastCooldown.start()

func _on_blast_cooldown_timeout():
	can_blast = true

# Called when hit by a bomb
func blast_behaviour():
	$StunCooldown.start()
	stunned = true
	$StunParticles.emitting = true
	
func _on_stun_cooldown_timeout():
	stunned = false
	$StunParticles.emitting = false
