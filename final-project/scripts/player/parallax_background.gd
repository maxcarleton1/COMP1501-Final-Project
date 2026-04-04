extends Node2D

enum possible_background {FOREST, DESERT, SNOW}

var current_background := possible_background.FOREST 

# Janky but whatever
@onready var player := $"../Player"
@onready var camera := $"../Camera2D"

var x_scroll_amount := 0.05
var y_scroll_amount := 0.01

func _ready() -> void:
	switch_background(possible_background.FOREST)
	recenter(player.global_position)

func _physics_process(delta: float) -> void:
	# Follow player movement
	global_position.x = player.global_position.x * x_scroll_amount
	global_position.y = camera.global_position.y - (player.global_position.y * y_scroll_amount)

func switch_background(background: possible_background):
	match background:
		possible_background.FOREST:
			$Forest.show()
			$Desert.hide()
			$Snow.hide()
		possible_background.DESERT:
			$Forest.hide()
			$Desert.show()
			$Snow.hide()
		possible_background.SNOW:
			$Forest.hide()
			$Desert.hide()
			$Snow.show()

# Resets position, upon reset or entering new area
func recenter(pos: Vector2):
	global_position = pos
