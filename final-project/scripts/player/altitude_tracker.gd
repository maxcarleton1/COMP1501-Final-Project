extends Node2D

@onready var player := get_tree().get_first_node_in_group("Player")

func _ready():
	global_position.y = 400
	$Label.text = "0m"

# Follows player Y value upwards
func _physics_process(delta: float):
	# Up = negative Y
	global_position.y = min(global_position.y, player.global_position.y)
	
	# This is janky but whateeever who give a shit :P
	if global_position.y < GlobalStats.best_altitude:
		GlobalStats.best_altitude = global_position.y
		$Label.text = "%.2fm" % (global_position.y * -0.01) # multiplying so it looks better

# Set position to best altitude
func reset():
	global_position.y = GlobalStats.best_altitude

# Add some signal/function to update HUD altimeter in player!
