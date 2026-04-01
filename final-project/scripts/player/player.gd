extends CharacterBody2D

@export var SPEED := 600
@export var DASH_SPEED := 1200
@export var ACCELERATION := 8000
@export var FRICTION := 50000
@export var AIR_FRICTION := 1500
@export var JUMP_VELOCITY := -650.0
@export var JUMP_HOLD_MULTIPLIER := 0.7

@export var DASH_TRAIL_FADE_TIME := 0.12
@export var DASH_TRAIL_ALPHA := 0.55
const PLAYER_GHOST_SCENE := preload("res://scenes/player/PlayerGhost.tscn")

# For losing
var MAX_FALL_SPEED := 2000

# For not losing!
var MAX_DROP_SPEED := 1000
var is_stunned := false

@onready var cold_manager = $ColdManager
#@onready var inventory_manager = $InventoryManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var coyote_time := 0.1
var coyote := true
var can_dash := true
var dash_speed_boost := false
var falling := false # When the player loses, they fall down

# Bomb logic
var bomb: RigidBody2D
const BOMB_ENTITY := preload("res://scenes/player/bomb_entity.tscn")
var unlocked_bomb := false
var can_bomb := false
# Fix???
var is_jump_velocity := false

#Grapple
const Grappler: PackedScene = preload("res://scenes/player/grapple_hook.tscn")

# Signals
signal player_start_fall
signal unlocked(item: int)

#Item Effects
var feather_falling_active: bool = false
var balloon_active: bool = false

func _ready():
	$BombCooldownBar.hide()
	$MeteorParticles.emitting = false
	$WalkEffect.emitting = false
	$CraterParticles.emitting = false
	
	if GlobalStats.current_difficulty != GlobalStats.difficulty.HELL_MODE:
		$StunTimer.wait_time = GlobalStats.difficulty_data.player_stun_duration

func fall():
	# Turn off most collision and fall, speeding up slowly
	falling = true
	velocity = Vector2.ZERO
	
	unlocked_bomb = false
	
	set_collision_mask_value(1, false) # Layer 1 = most ground/interactable objects, not including walls (Layer 2 also)
	set_collision_layer_value(5, true) # Layer 5 = stop lose barrier (in start_room)
	
	$WalkEffect.emitting = false
	$StunParticles.emitting = false
	
	unlocked.emit(0)
	
	var tween = create_tween()
	if $AnimatedSprite2D.flip_h: # Always face downwards
		tween.tween_property($AnimatedSprite2D, "rotation_degrees", 90, 1)
	else:
		tween.tween_property($AnimatedSprite2D, "rotation_degrees", -90, 1)
		
	await get_tree().create_timer(2).timeout
	$MeteorParticles.emitting = true
	
func stop_fall():
	# Turn on collision and restore movement
	falling = false
	$PlayerSFXManager/Landing.play()
	$ColdManager.coldness = 0
	set_collision_mask_value(1, true) # Layer 1 = most ground/interactable objects
	set_collision_layer_value(5, false) # Layer 5 = stop lose barrier (in start_room)
	
	$MeteorParticles.emitting = false
	
	$AnimatedSprite2D.rotation_degrees = 0
	
	$CraterParticles.emitting = true

# Called when an obstacle wants the player to lose on hit
func get_hit_by_obstacle(insta_lose: bool = false):
	if insta_lose or GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE: # Barrier, dust devil, cold, and hell mode obstacles
		if not falling: # Seeing as this can be triggered by any obstacle
			$PlayerSFXManager/Death.play()
			# Emit to main, which will delegate resetting, etc. to individual scenes
			player_start_fall.emit()
			
			# Resetting inventory stuff here
			# Holding off until inventory is more fleshed out
			# $InventoryManager.clearItems()
			# $InventoryManager.clearUpgrades() ???
			
			fall()
	else: # Most obstacles in normal/hard mode
		get_stunned()

# Called when an obstacle wants to temporarily stun the player
func get_stunned():
	if $StunCooldownTimer.is_stopped():
		is_stunned = true
		$StunTimer.start()
		$StunParticles.emitting = true

func _on_stun_timer_timeout():
	is_stunned = false
	$StunCooldownTimer.start()
	$StunParticles.emitting = false

func _physics_process(delta: float):
	var direction := 0.0
	if not falling:
		calculate_coyote(delta)
		if dash_speed_boost:
			spawn_dash_ghost()
		
		if not is_on_floor() and not dash_speed_boost: # Gravity
			velocity += get_gravity() * 1.5 * delta
			
		if is_on_floor():
			is_jump_velocity = false

		if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote) and not is_stunned:
			velocity.y = JUMP_VELOCITY
			$PlayerSFXManager/Jump.play()
			is_jump_velocity = true
		if Input.is_action_just_released("Jump") and velocity.y < 0 and is_jump_velocity:
			velocity.y *= JUMP_HOLD_MULTIPLIER
		
		direction = Input.get_axis("MoveLeft", "MoveRight")
		if direction != 0 and !dash_speed_boost and not is_stunned:
			velocity.x = move_toward(velocity.x, get_speed() * direction, ACCELERATION * delta)
		elif direction != 0 and not is_stunned:
			velocity.x = move_toward(velocity.x, (get_speed() + 500) * direction, ACCELERATION * delta)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
			
		# Walking particle effect
		if is_on_floor():
			if velocity.x < 0:
				$WalkEffect.emitting = true
				$WalkEffect.scale.x = 1
			elif velocity.x > 0:
				$WalkEffect.emitting = true
				$WalkEffect.scale.x = -1
			else:
				$WalkEffect.emitting = false
		else:
			$WalkEffect.emitting = false
			
		if Input.is_action_just_pressed("Dash") and can_dash and not is_stunned:
			can_dash = false
			dash_speed_boost = true
			$DashCooldown.start()
			$DashSpeedBoost.start()
			$PlayerSFXManager/Dash.play()
			if Input.is_action_pressed("Down") and direction == 0:
				velocity.y = get_dashspeed()
				velocity.x = 0
			elif Input.is_action_pressed("Down"):
				velocity.y = get_dashspeed() / 1.7
				velocity.x = get_dashspeed() * direction
			else:
				velocity.x = direction * get_dashspeed()
				velocity.y = 0
				
		# Clamp drop (NOT FALL) speed (lol)
		velocity.y = clamp(velocity.y, -INF, MAX_DROP_SPEED)
				
		if unlocked_bomb and not is_stunned:
			if Input.is_action_just_pressed("Bomb") and can_bomb and not bomb and not falling:
				# bomb logic here
				spawn_bomb()
				
				$BombCooldown.start()
				$BombCooldownBar.show()
				can_bomb = false
			var percentage_time: float = (1.0 - $BombCooldown.time_left / $BombCooldown.wait_time) * 100.0
			$BombCooldownBar.value = 100.0 - percentage_time

		if(feather_falling_active and velocity.y > 0):
			velocity.y *= 0.9
			
		if(balloon_active):
			velocity.y = -200
			
	else: # Falling
		
		velocity = velocity.move_toward(Vector2(0, MAX_FALL_SPEED), get_gravity().y * delta * 0.5)
	
	move_and_slide()

func get_speed():
	return SPEED + InventoryManager.speedModifier

func get_dashspeed():
	return DASH_SPEED + InventoryManager.dashSpeedModifier

func calculate_coyote(delta: float):
	if !is_on_floor():
		coyote_time -= delta
	else:
		coyote_time = 0.1
		
	if coyote_time < 0:
		coyote = false
	else:
		coyote = true

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_dash_speed_boost_timeout() -> void:
	dash_speed_boost = false

func spawn_dash_ghost() -> void:
	var ghost := PLAYER_GHOST_SCENE.instantiate() as Sprite2D

	ghost.global_position = animated_sprite.global_position
	ghost.scale = animated_sprite.global_scale
	ghost.z_index = z_index - 1
	ghost.modulate.a = DASH_TRAIL_ALPHA

	get_parent().add_child(ghost)

	var tween := create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, DASH_TRAIL_FADE_TIME)
	tween.finished.connect(ghost.queue_free)

func pickup_coin():
	$PlayerSFXManager/PickupCoin.play()
	
# Bomb logic
func unlock_bomb():
	unlocked_bomb = true
	$BombCooldown.start()
	
	$BombCooldownBar.show()
	
	# 1 = bomb
	unlocked.emit(1)

func spawn_bomb():
	if not bomb: # Just to prevent spawning one right when you explode one
		bomb = BOMB_ENTITY.instantiate()
		get_parent().add_child(bomb)
		bomb.global_position = global_position
		bomb.linear_velocity = velocity * 0.8 # Just a bit slower so it lags behind you slightly
	
func _on_bomb_cooldown_timeout():
	can_bomb = true
	$BombCooldownBar.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	for i in range(5): #5 Inventory slots
		if (event.is_action_pressed("Hotbar_" + str(i + 1))):
			InventoryManager.select_hotbar_slot(i)
			break
	
	# Controller support
	if event.is_action_pressed("HotbarNext"):
		InventoryManager.select_hotbar_slot((InventoryManager.selected_hotbar_index + 1) % InventoryManager.HOTBAR_SIZE)
	elif event.is_action_pressed("HotbarPrevious"):
		InventoryManager.select_hotbar_slot((InventoryManager.selected_hotbar_index - 1 + InventoryManager.HOTBAR_SIZE) % InventoryManager.HOTBAR_SIZE)
	
	if(event.is_action_pressed("Use_item")):
		InventoryManager.use_selected_item(self)

func unlock_grapple():
	var grappler = Grappler.instantiate()
	call_deferred("add_child",grappler)
	
	# 2 = grapple
	unlocked.emit(2)
func activate_feather_falling(seconds: int) -> void:
	seconds_invalid_check(seconds)
	print("Feather falling activated")
	feather_falling_active = true
	await get_tree().create_timer(seconds).timeout
	feather_falling_active = false
	
func activate_balloon(seconds: int) -> void:
	seconds_invalid_check(seconds)
	print("Balloon activated")
	balloon_active = true
	await get_tree().create_timer(seconds).timeout
	balloon_active = false
	
func seconds_invalid_check(seconds: int):
	if seconds <= 0:
		print("Seconds should be > 0 for item effects")
