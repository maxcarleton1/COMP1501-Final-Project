extends Node2D

#variables to be set in inspector
@export var travel_distance: float = 120.0
@export var drop_speed: float = 400.0
@export var retract_speed: float = 80.0
@export var wait_top: float = 1.5
@export var wait_bottom: float = 1.0

@onready var rope: Line2D = $Rope
@onready var ropetop: Marker2D = $Anchor/Marker2D
@onready var ropebottom: Marker2D = $Dynamic/Marker2D
@onready var obstacle: Node2D = $Dynamic

var top_y: float
var bottom_y: float

enum {WAIT_TOP, DROP, WAIT_BOTTOM, RETRACT}
var state = WAIT_TOP

func _ready() -> void:
	top_y = obstacle.position.y
	bottom_y = top_y + travel_distance
	start_wait(wait_top)

func _physics_process(delta: float) -> void:
	match state:
		DROP:
			obstacle.position.y += drop_speed * delta
			if obstacle.position.y >= bottom_y:
				obstacle.position.y = bottom_y
				state = WAIT_BOTTOM
				start_wait(wait_bottom)
		
		RETRACT:
			obstacle.position.y -= retract_speed * delta
			if obstacle.position.y <= top_y:
				obstacle.position.y = top_y
				state = WAIT_TOP
				start_wait(wait_top)

func _process(delta: float) -> void:
	rope.clear_points()
	rope.add_point(Vector2(0,0))
	rope.add_point(Vector2(0, obstacle.position.y - 9))

func start_wait(time) -> void:
	await get_tree().create_timer(time).timeout
	if state == WAIT_TOP:
		state = DROP
	elif state == WAIT_BOTTOM:
		state = RETRACT
