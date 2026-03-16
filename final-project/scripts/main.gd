extends Node

var barrier_spawn_pos: Vector2 = Vector2(0, 750)
@onready var barrier := $LoseBarrier

func _ready() -> void:
	barrier.player_contact.connect(fall_down)
	barrier.global_position = barrier_spawn_pos
	
	$LevelBuilder.start_barrier.connect(start_barrier)
	$LevelBuilder.start_barrier.connect(start_barrier)
		
func start_barrier():
	barrier.started = true

# Called upon hitting the lose barrier etc.
# Makes player fall back down to the start, ignoring anything in the way
func fall_down():
	barrier.started = false
	barrier.global_position = barrier_spawn_pos
	$Player.fall()
