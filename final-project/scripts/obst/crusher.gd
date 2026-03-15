extends Node2D

#variables to be set in inspector
@export var travel_distance: float = 120.0
@export var drop_speed: float = 400.0
@export var retract_speed: float = 80.0
@export var wait_top: float = 1.5
@export var wait_bottom: float = 1.0

var top_y: float
var bottom_y: float

enum {WAIT_TOP, DROP, WAIT_BOTTOM, RETRACT}
var state = WAIT_TOP

func _ready() -> void:
	add_to_group("Obstacles")
	top_y = position.y
	bottom_y = top_y + travel_distance
	start_wait(wait_top)

func _physics_process(delta: float) -> void:
	match state:
		DROP :
			position.y += drop_speed * delta
			if position.y >= bottom_y:
				position.y = bottom_y
				state = WAIT_BOTTOM
				start_wait(wait_bottom)

		RETRACT:
			position.y -= retract_speed * delta
			if position.y <= top_y:
				position.y = top_y
				state = WAIT_TOP
				start_wait(wait_top)

func start_wait(time) -> void:
	await get_tree().create_timer(time).timeout
	if state == WAIT_TOP:
		state = DROP
	elif state == WAIT_BOTTOM:
		state = RETRACT
