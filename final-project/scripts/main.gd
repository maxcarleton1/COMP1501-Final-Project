extends Node

var barrier_spawn_pos: Vector2 = Vector2(0, 800)
@onready var barrier := $LoseBarrier
@onready var start_room := $LevelBuilder/StartRoom
@onready var end_room := $LevelBuilder/EndRoom
@onready var player := $Player

#Physical shop item on the map's interaction area 
@onready var shop_stand := $LevelBuilder/StartRoom/Shop/InteractionArea
#Main window for the economy being displayed
@onready var economy_display = $EconomyDisplay

func _ready() -> void:
	
	#Economy display window containing upgrades/items to be displayed
	economy_display.hide()
	shop_stand.economy_display_requested.connect(economy_display.toggle_economy_display)
	shop_stand.economy_display_close_requested.connect(economy_display.close_economy_display)
	
	# Start room (starting the run, resetting levels upon hitting the bottom/loss)
	start_room.start_run.connect(start_run)
	start_room.hit_bottom.connect(reset_run)
	
	# End room (winning the game by reaching the top)
	end_room.win_hitbox.connect(win)
	
	# Player (beginning the fall)
	player.player_start_fall.connect(reset_barrier)
	
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

func reset_barrier():
	# Reset barrier
	barrier.reset(barrier_spawn_pos, true)
	
func win():
	print("You win!")
