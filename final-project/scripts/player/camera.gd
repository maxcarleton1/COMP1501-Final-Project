extends Camera2D

@onready var player := get_tree().get_first_node_in_group("Player")

var prev_camera_position_y: float = global_position.y
var tracking_speed: float = 1.5

func _ready():
	global_position.x = 0

func _physics_process(delta: float):
	# Camera movement (smoothed)
	global_position.y = lerp(prev_camera_position_y, player.global_position.y, delta * tracking_speed)
	global_position.y = clampf(global_position.y, -INF, 0) # Clamp to floor/ceiling
	prev_camera_position_y = global_position.y
	
	# This works but results in jittery movement
	#$Camera2D.position_smoothing_enabled = true
