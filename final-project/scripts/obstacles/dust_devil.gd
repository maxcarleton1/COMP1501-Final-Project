extends Node2D

var enabled: bool = false
var player: CharacterBody2D

func _ready() -> void:
	# Sprites and collision
	$VortexSprite.scale.x = GlobalStats.difficulty_data.dust_devil_width_scale
	$WarningSprite.scale.x = GlobalStats.difficulty_data.dust_devil_width_scale
	$VortexArea/CollisionShape2D.scale.x = GlobalStats.difficulty_data.dust_devil_width_scale
	
	# Timers
	$DustDevilCooldown.wait_time = GlobalStats.difficulty_data.dust_devil_cooldown
	$DustDevilTimer.wait_time = GlobalStats.difficulty_data.dust_devil_timer
	$WarnTimer.wait_time = 2 # static, whatever
	
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float):
	if enabled:
		# Follows y position of player
		global_position.y = player.global_position.y
	# Step 1: Spawn
	# Upon DustDevilCooldown timeout,

# Step 2: Warn
# Shows WarningSprite, plays SFX, starts WarnTimer,
# then on WarnTimer timeout moves to step 3

# Step 3: Vortex
# Hides WarningSprite, shows VortexSprite and plays it,
# starts DustDevilTimer, turns on collision box for VortexArea

# Step 4: Reset
# Upon DustDevilTimer timeout, starts DustDevilCooldown,
# Hides VortexSprite, disables collision box for VortexArea

func _on_dust_devil_cooldown_timeout():
	var padding = $VortexArea/CollisionShape2D.shape.x * GlobalStats.difficulty_data.dust_devil_width_scale
	var min_x: int
	var max_x: int
	var spawn_x: int
	
	# On normal: Randomly chooses an x position within the screen boundaries (about -960 to 960)
	if GlobalStats.current_difficulty == GlobalStats.difficulty.NORMAL:
		min_x = -960 + padding
		max_x = 960 - padding
	else: # On hard/hell mode: Chooses an x position closer to the player
		min_x = player.global_position.x + padding
		max_x = player.global_position.x - padding
	
	spawn_x = randi_range(min_x, max_x)
	$Dust
		
func _on_dust_devil_timer_timeout():
	pass # Replace with function body.

func _on_warn_timer_timeout():
	pass # Replace with function body.
