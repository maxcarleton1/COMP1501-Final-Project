extends Node2D

var enabled: bool = false
var player: CharacterBody2D
@onready var preset_warning_scale: float = $WarningSprite.scale.x

func _ready() -> void:
	# Sprites and collision
	$WarningSprite.scale.x = GlobalStats.difficulty_data.dust_devil_width_scale + preset_warning_scale
	$WarningSprite.scale.y = GlobalStats.difficulty_data.dust_devil_width_scale + preset_warning_scale
	$VortexArea/CollisionShape2D.scale.x = GlobalStats.difficulty_data.dust_devil_width_scale
	$VortexArea/CollisionShape2D.set_deferred("disabled", true)
	
	# Particle emitter width
	$GPUParticles2D.process_material.emission_shape_scale.x = GlobalStats.difficulty_data.dust_devil_width_scale
	
	# Timers
	$DustDevilCooldown.wait_time = GlobalStats.difficulty_data.dust_devil_cooldown
	$DustDevilTimer.wait_time = GlobalStats.difficulty_data.dust_devil_timer
	$WarnTimer.wait_time = 2 # static, whatever
	
	player = get_tree().get_first_node_in_group("Player")
	
	# Start tween loop
	fade_loop()
	$WarningSprite.hide()
	$GPUParticles2D.emitting = false
	$AnimationPlayer.play("laugh")
	$VortexSprite.modulate.a = 0.0

func _physics_process(delta: float):
	if enabled:
		# Follows y position of camera, so damn janky but who gaf
		global_position.y = $"../Camera2D".global_position.y

# Initial call by entering area 2's levels
func start():
	enabled = true
	$DustDevilCooldown.start()

func stop():
	$VortexArea/CollisionShape2D.set_deferred("disabled", true)
	enabled = false
	
	$GPUParticles2D.emitting = false
		
	var tween = create_tween()
	tween.tween_property($VortexSprite, "modulate:a", 0, 0.3)
	
	$DustDevilCooldown.stop()
	$DustDevilTimer.stop()
	$WarnTimer.stop()
	$WarningSprite.hide()

# Helper for warning sprite
func fade_loop():
	var tween = create_tween().set_loops()
	tween.tween_property($WarningSprite, "modulate:a", 0.25, 0.5)
	tween.tween_property($WarningSprite, "modulate:a", 1.0, 0.5)

func _on_dust_devil_cooldown_timeout():
	# Step 1: Spawn
	var padding = $VortexArea/CollisionShape2D.shape.get_rect().size.x * GlobalStats.difficulty_data.dust_devil_width_scale
	var min_x: int = -960 + padding
	var max_x: int = 960 - padding
	
	# On normal: Randomly chooses an x position within the screen boundaries (inside -960 to 960)
	# On hard/hell mode: Chooses an x position closer to the player
	if GlobalStats.current_difficulty != GlobalStats.difficulty.NORMAL:
		min_x = player.global_position.x + padding
		max_x = player.global_position.x - padding
		# Keep inside level bounds
		min_x = clampi(min_x, -960 + padding, max_x)
		min_x = clampi(min_x, 960 - padding, max_x)
	
	var spawn_x := randi_range(min_x, max_x)
	
	global_position.x = spawn_x
	
	# Step 2: Warn
	# Shows WarningSprite, plays SFX, starts WarnTimer, then on WarnTimer timeout moves to step 3
	$WarningSprite.show()
	$WarnTimer.start()

func _on_warn_timer_timeout():
	# Step 3: Vortex
	# Hides WarningSprite, shows VortexSprite and plays it, starts DustDevilTimer, turns on collision box for VortexArea
	
	# Tween for fading nicely
	var tween = create_tween()
	tween.tween_property($VortexSprite, "modulate:a", 1.0, 0.5)
	
	$WarningSprite.hide()
	$GPUParticles2D.emitting = true
	$VortexSprite.play("default")
	$VortexArea/CollisionShape2D.set_deferred("disabled", false)
	$DustDevilTimer.start()
	
func _on_dust_devil_timer_timeout():
	# Step 4: Reset
	# Upon DustDevilTimer timeout, starts DustDevilCooldown, hides VortexSprite, disables collision box for VortexArea
	
	# Tween for fading nicely
	var tween = create_tween()
	tween.tween_property($VortexSprite, "modulate:a", 0, 0.5)
	
	$VortexSprite.stop()
	$GPUParticles2D.emitting = false
	$VortexArea/CollisionShape2D.set_deferred("disabled", true)
	$DustDevilCooldown.start()

# Lose and shit
func _on_vortex_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		body.get_hit_by_obstacle()
	if body.is_in_group("InteractiveObstacle"):
		body.blast_behaviour()
