extends Node2D
#incomplete
#in progress
#actual player interaction to come

@export var swing_period := 2.0   # seconds for one full swing
@export var swing_angle := 45.0   # degrees
@export var rope_length := 100.0 # pixels

@onready var handle = $Pivot/Handle
@onready var pivot = $Pivot
@onready var rope = $Pivot/Rope

var time := 0.0

func _process(delta: float) -> void:
	time += delta
	var period = swing_period
	if period <= 0:
		period = 1.0
	rotation_degrees = sin(time * 2 * PI / period) * swing_angle
	handle.position = Vector2(0, rope_length)
	update_chain()

func update_chain():
	rope.clear_points()
	rope.add_point(Vector2.ZERO)
	rope.add_point(Vector2(0, rope_length))


func _on_handle_body_entered(body: Node2D) -> void:
	pass


func _on_handle_body_exited(body: Node2D) -> void:
	return
	$Pivot/Handle.monitoring = false
	await get_tree().create_timer(0.2).timeout
	$Pivot/Handle.monitoring = true
