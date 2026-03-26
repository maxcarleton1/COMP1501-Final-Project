extends Sprite2D

var Points: Array[Sprite2D]
var closestPoint: Vector2
var active = false
const TARGET_HIT_TOLERANCE := 50.0
@onready var raycast: RayCast2D = $RayCast2D

func _ready() -> void:
	closestPoint = Vector2(INF,INF)
	var player := get_parent()
	if player is CollisionObject2D:
		raycast.add_exception(player)

func _input(event: InputEvent):
	if event.is_action_pressed("Grapple"):
		if findClosestPoint():
			grappleToPoint()

func _on_grapple_range_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("GrapplePoint"):
		Points.append(area.get_parent())

func _process(delta):
	if active:
		$Line2D.set_point_position(0, Vector2.ZERO)
		$Line2D.set_point_position(1, to_local(closestPoint))
	else:
		$Line2D.set_point_position(0, Vector2.ZERO)
		$Line2D.set_point_position(1, Vector2.ZERO)
func _on_grapple_range_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("GrapplePoint"):
		var point_index := Points.find(area.get_parent())
		if point_index != -1:
			Points.remove_at(point_index)

func findClosestPoint() -> bool:
	closestPoint = Vector2(INF, INF)
	for Point in Points:
		if not is_instance_valid(Point):
			continue
		if not _has_line_of_sight(Point.global_position):
			continue
		if global_position.distance_to(closestPoint) > global_position.distance_to(Point.global_position):
			closestPoint = Point.global_position
	return closestPoint != Vector2(INF, INF)

func _has_line_of_sight(target_position: Vector2) -> bool:
	raycast.global_position = global_position
	raycast.target_position = target_position - global_position
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		return true
	var collision_point := raycast.get_collision_point()
	return collision_point.distance_to(target_position) <= TARGET_HIT_TOLERANCE

func grappleToPoint():
	if closestPoint != Vector2(INF, INF):
		active = true
		var tween = create_tween()
		var player = get_parent()
		$Line2D.set_point_position(1,to_local(closestPoint))
		tween.tween_property(player, "position", closestPoint, 0.5)
		player.velocity = Vector2.ZERO
		tween.finished.connect(func(): doneGrapple())

func doneGrapple():
	active = false
