extends Node

var barrier_spawn_pos: Vector2 = Vector2(0, 800)
@onready var barrier := $LoseBarrier
@onready var start_room := $LevelBuilder/StartRoom
@onready var end_room := $LevelBuilder/EndRoom
@onready var player := $Player

func _ready() -> void:
	# Start room (starting the run, resetting levels upon hitting the bottom/loss)
	start_room.start_run.connect(start_run)
	start_room.hit_bottom.connect(reset_run)
	
	# End room (winning the game by reaching the top)
	end_room.win_hitbox.connect(win)
	
	# Player (beginning the fall)
	player.player_start_fall.connect(fall_down)
	
	# This is just so the player doesn't drop on game startup
	$Player.global_position = $LevelBuilder/StartRoom/StopFall/CollisionShape2D.global_position

# Resets rooms, barrier, stats, etc.
func reset_run():
	if player.falling: # Just to be sure 
		barrier.reset(barrier_spawn_pos, true)
		$LevelBuilder.regenerate()
		
		$AltitudeTracker.reset() # Needed?

func start_run():
	# Start barrier
	barrier.start_moving()

func fall_down():
	# Reset barrier
	barrier.reset(barrier_spawn_pos, true)
	
func win():
	print("You win!")
