extends CharacterBody2D

@export var SPEED := 600
@export var DASH_SPEED := 1200
@export var ACCELERATION := 8000
@export var FRICTION := 10000
@export var AIR_FRICTION := 1000
@export var JUMP_VELOCITY := -800.0
@export var JUMP_HOLD_MULTIPLIER := 0.7

var coyote_time := 0.1
var coyote := true
var can_dash := true
var dash_speed_boost := false
var falling := false # When the player loses, they fall down

func fall():
	# Turn off most collision and fall at a constant rate
	falling = true
	velocity = Vector2.ZERO
	
	set_collision_mask_value(1, false) # Layer 1 = most ground/interactable objects, not including walls (Layer 2 also)
	set_collision_layer_value(5, true) # Layer 5 = lose barrier
	
func stop_fall():
	# Turn on collision and restore movement
	falling = false
	
	set_collision_mask_value(1, true) # Layer 1 = most ground/interactable objects
	set_collision_layer_value(5, false) # Layer 5 = lose barrier

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
			velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
		elif direction != 0:
			velocity.x = move_toward(velocity.x, (SPEED + 500) * direction, ACCELERATION * delta) 
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
				velocity.y += DASH_SPEED
				velocity.x = 0
			elif Input.is_action_pressed("Down"):
				velocity.y += DASH_SPEED / 1.7
				velocity.x = DASH_SPEED * direction
			else:
				velocity.x = direction * DASH_SPEED

	else: # Falling
		velocity = velocity.move_toward(Vector2(0, 500), get_gravity().y * delta)
		
	move_and_slide()

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
