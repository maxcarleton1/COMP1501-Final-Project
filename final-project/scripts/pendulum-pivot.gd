extends Node2D

@export var swing_speed := 2.0
@export var swing_angle := 45.0   # degrees

@onready var blade = $Blade
@onready var chain = $Chain

var time := 0.0

func _process(delta):
	time += delta
	rotation_degrees = sin(time * swing_speed) * swing_angle
	update_chain()

func update_chain():
	chain.clear_points()
	chain.add_point(Vector2.ZERO)
	chain.add_point(blade.position)
