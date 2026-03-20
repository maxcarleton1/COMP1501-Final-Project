extends CharacterBody2D

@export var SPEED := 600
@export var DASH_SPEED := 1200
@export var ACCELERATION := 8000
@export var FRICTION := 10000
@export var AIR_FRICTION := 1000
@export var JUMP_VELOCITY := -650.0
@export var JUMP_HOLD_MULTIPLIER := 0.7
var MAX_FALL_SPEED := 750

@onready var inventory_manager = $InventoryManager

var coyote_time := 0.1
var coyote := true
var can_dash := true
var dash_speed_boost := false
var falling := false # When the player loses, they fall down

signal player_start_fall

func fall():
	# Turn off most collision and fall at a constant rate
	falling = true
	velocity = Vector2.ZERO
	
	set_collision_mask_value(1, false) # Layer 1 = most ground/interactable objects, not including walls (Layer 2 also)
	set_collision_layer_value(5, true) # Layer 5 = stop lose barrier (in start_room)
	
func stop_fall():
	# Turn on collision and restore movement
	falling = false
	
	set_collision_mask_value(1, true) # Layer 1 = most ground/interactable objects
	set_collision_layer_value(5, false) # Layer 5 = stop lose barrier (in start_room)

# Called when an obstacle wants the player to lose on hit
func get_hit_by_obstacle():
	if not falling: # Seeing as this can be triggered by any obstacle
		# Emit to main, which will delegate resetting, etc. to individual scenes
		player_start_fall.emit()
		
		# Resetting inventory stuff here
		# Holding off until inventory is more fleshed out
		# $InventoryManager.clearItems()
		# $InventoryManager.clearUpgrades() ???
		
		fall()

func _physics_process(delta: float):
	if not falling:
		calculate_coyote(delta)
		
		if not is_on_floor(): # Gravity
			velocity += get_gravity() * 1.5 * delta
			
		if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote):
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_released("Jump") and velocity.y < 0:
			velocity.y *= JUMP_HOLD_MULTIPLIER

		var direction := Input.get_axis("MoveLeft", "MoveRight")
		if direction != 0 and !dash_speed_boost:
			velocity.x = move_toward(velocity.x, get_speed() * direction, ACCELERATION * delta)
		elif direction != 0:
			velocity.x = move_toward(velocity.x, (get_speed() + 500) * direction, ACCELERATION * delta) 
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta) 
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta) 
		if Input.is_action_just_pressed("Dash"):
			can_dash = false
			dash_speed_boost = true
			$DashCooldown.start()
			$DashSpeedBoost.start()
			if Input.is_action_pressed("Down") and direction == 0:
				velocity.y += get_dashspeed()
				velocity.x = 0
			elif Input.is_action_pressed("Down"):
				velocity.y += get_dashspeed() / 1.7
				velocity.x = get_dashspeed() * direction
			else:
				velocity.x = direction * get_dashspeed()

	else: # Falling
		velocity = velocity.move_toward(Vector2(0, MAX_FALL_SPEED), get_gravity().y * delta)
	
	move_and_slide()

func get_speed():
	return SPEED + inventory_manager.speedModifier

func get_dashspeed():
	return DASH_SPEED + inventory_manager.dashSpeedModifier

func calculate_coyote(delta:float):
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
