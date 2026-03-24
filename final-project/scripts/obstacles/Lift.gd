#plays in editor so the path can update
@tool
extends Node2D

@export var travel_time: float = 2.0 #in seconds
@export var wait_time: float = 2.0 #in seconds
@export var offset_time: float = 0.0 #in seconds
@export var destination: Vector2 = Vector2(0.0, -72.0)

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var platform: AnimatableBody2D = $Path2D/PathFollow2D/Platform

var t: float = 0.0
var direction: int = 1
var waiting: bool

func _ready() -> void:
	var path: Path2D = $Path2D
	if path.curve:
		path.curve = path.curve.duplicate(true)
	_update_platform_editor()
	update_path_point()
	if Engine.is_editor_hint():
		platform.global_position = path_follow.global_position
	
	path_follow.progress_ratio = t
	platform.global_position = path_follow.global_position
	waiting = true
	wait_and_switch(offset_time, 1)
	#sprite scale
	var ratio = 64.0/18.0
	$Path2D/PathFollow2D/Platform/Sprite2D.scale = Vector2(ratio, ratio)
	$Path2D/PathFollow2D/Platform/Sprite2D2.scale = Vector2(ratio, ratio)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update_platform_editor()

func _physics_process(delta: float) -> void:
	if waiting:
		return
	
	t += direction * delta / travel_time
	t = clamp(t, 0.0, 1.0)
	path_follow.progress_ratio = t
	platform.global_position = path_follow.global_position
	
	if t <= 0.0 or t >= 1.0:
		waiting = true
		wait_and_switch(wait_time, -1)

func _draw():
	if Engine.is_editor_hint():
		var curve = $Path2D.curve
		if curve.get_point_count() >= 2:
			draw_line(curve.get_point_position(0), curve.get_point_position(1), Color.RED, 2)

func update_path_point() -> void:
	var curve = $Path2D.curve
	if curve.get_point_count() < 2:
		curve.add_point(destination)
	else:
		curve.set_point_position(1, destination)
	# force PathFollow2D to update
	_update_platform_editor()

func _update_platform_editor() -> void:
	if not Engine.is_editor_hint():
		return
	path_follow.progress_ratio = t
	platform.global_position = path_follow.global_position

func wait_and_switch(time: float, change: int) -> void:
	await get_tree().create_timer(time).timeout
	direction *= change
	waiting = false
