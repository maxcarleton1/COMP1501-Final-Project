extends CharacterBody2D

@export var SPEED := 600
@export var DASHSPEED := 1200
@export var ACCELORATION := 8000
@export var FRICTION :=10000
@export var AIRFRICTION := 1000
@export var JUMP_VELOCITY := -800.0
@export var JUMP_HOLD_MULTIPLIER:= 0.7

var coyote_time := 0.1
var coyote := true
var canDash := true
var dashSpeedBoost := false
var falling := false # When the player loses, they fall down
func fall():
	# Turn off all collision and fall at a constant rate
	falling = true
	velocity = Vector2.ZERO
	
	$CollisionShape2D.set_deferred("disabled", true)
	
func stop_fall():
	# Turn on collision and restore movement
	falling = false
	
	$CollisionShape2D.set_deferred("disabled", false)

func _physics_process(delta: float):
	if not falling:
		calculate_coyote(delta)
		
		if not is_on_floor(): # Gravity
			velocity += get_gravity()*1.5 * delta
			
		if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote):
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_released("Jump") and velocity.y < 0:
			velocity.y *= JUMP_HOLD_MULTIPLIER

		var direction := Input.get_axis("MoveLeft", "MoveRight")
		if direction != 0 and !dashSpeedBoost:
			velocity.x = move_toward(velocity.x,SPEED * direction, ACCELORATION * delta)
		elif direction != 0:
			velocity.x = move_toward(velocity.x, (SPEED+500) * direction,ACCELORATION * delta) 
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION* delta) 
		else:
			velocity.x = move_toward(velocity.x, 0, AIRFRICTION* delta) 
		if Input.is_action_just_pressed("Dash"):
			canDash= false
			dashSpeedBoost = true
			$DashCooldown.start()
			$DashSpeedBoost.start()
			if Input.is_action_pressed("Down") and direction == 0:
				velocity.y += DASHSPEED
				velocity.x = 0
			elif Input.is_action_pressed("Down"):
				velocity.y += DASHSPEED/1.7
				velocity.x = DASHSPEED*direction
			else:
				velocity.x = direction *DASHSPEED

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
	canDash = true


func _on_dash_speed_boost_timeout() -> void:
	dashSpeedBoost = false
