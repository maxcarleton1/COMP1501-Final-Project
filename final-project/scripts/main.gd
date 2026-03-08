extends Node

var barrier_spawn_pos: Vector2 = Vector2(0, 750)

func _ready() -> void:
	$LoseBarrier.player_contact.connect(fall_down)
	$LoseBarrier.global_position = barrier_spawn_pos
		
# Called upon hitting the lose barrier etc.
# Makes player fall back down to the start, ignoring anything in the way
func fall_down():
	$Player.fall()
