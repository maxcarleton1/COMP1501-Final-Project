extends Camera2D

@onready var player := get_tree().get_first_node_in_group("Player")

var prev_camera_position_y: float = global_position.y
var tracking_speed: float = 1.5
var look_ahead_speed: float = 0.5
var camera_y_offset: float = -200 # Stays slightly above the player

func _ready():
	global_position.x = 0

func _physics_process(delta: float):
	var look_ahead = player.velocity.y * look_ahead_speed

	# Tries to stay ahead of the player at some target
	var target_y = player.global_position.y + look_ahead + camera_y_offset
	
	# Interpolate to the target position
	global_position.y = lerp(prev_camera_position_y, target_y, delta * tracking_speed)

	# Clamp it to the world boundaries
	global_position.y = clampf(global_position.y, -INF, 0)
	prev_camera_position_y = global_position.y
