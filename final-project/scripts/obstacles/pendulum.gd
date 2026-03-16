extends Node2D

@export var swing_period := 2.0   # seconds for one full swing
@export var swing_angle := 45.0   # degrees
@export var chain_length := 100.0 # pixels

@onready var pivot = $Pivot
@onready var blade = $Pivot/Blade
@onready var chain = $Pivot/Chain

var time := 0.0

func _process(delta):
	time += delta
	var period = swing_period
	if period <= 0:
		period = 1.0
	rotation_degrees = sin(time * 2 * PI / period) * swing_angle
	blade.position = Vector2(0, chain_length)
	update_chain()

func update_chain():
	chain.clear_points()
	chain.add_point(Vector2.ZERO)
	chain.add_point(Vector2(0, chain_length))

func _on_blade_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.fall()
		print("Damage Detected")
