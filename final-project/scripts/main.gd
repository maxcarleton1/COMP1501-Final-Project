extends Node

# Obstacles
var barrier_spawn_pos: Vector2 = Vector2(0, 800)
@onready var barrier := $LoseBarrier
@onready var dust_devil := $DustDevil

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
	start_room.start_run.connect(start_barrier)
	start_room.hit_bottom.connect(reset_run)
	
	# End room (winning the game by reaching the top)
	end_room.win_hitbox.connect(win)
	
	# Player (beginning the fall)
	player.player_start_fall.connect(reset_barrier)
	player.player_start_fall.connect(reset_dust_devil)
	player.player_start_fall.connect(reset_timer)
	
	# Player (updating controls UI)
	player.unlocked.connect($HUD/PauseMenu.unlocked)
	
	# This is just so the player doesn't drop on game startup
	$Player.global_position = $LevelBuilder/StartRoom/StopFall/CollisionShape2D.global_position

# Resets rooms, barrier, stats, etc.
func reset_run():
	if player.falling: # Just to be sure 
		# Obstacles
		reset_barrier()
		reset_dust_devil()
		
		$LevelBuilder.regenerate()
		
		$AltitudeTracker.reset() # Needed?

func start_barrier():
	if not barrier.started:
		barrier.start_moving()
		# Doin this here cause whatever
		$HUD/TimerLayer.started = true

func reset_barrier():
	barrier.reset(barrier_spawn_pos, true)
	
func reset_dust_devil():
	dust_devil.stop()

func reset_timer():
	$HUD/TimerLayer.reset()

func start_dust_devil():
	if not dust_devil.enabled:
		dust_devil.start()
	
func win():
	$HUD/TimerLayer.started = false
	$HUD/TimerLayer.check_best_time()
