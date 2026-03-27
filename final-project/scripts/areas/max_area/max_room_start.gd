extends Node2D

var platform_extended := true

signal start_devil

func _ready():
	if not has_node("Entries"):
		push_error("Missing required child node: Entries")
	if not has_node("Exits"):
		push_error("Missing required child node: Exits")
		
	retract_platform()
	
	# Ts janky ahh hell but who gaf
	var main = get_parent().get_parent()
	if main.has_method("start_dust_devil"):
		start_devil.connect(main.start_dust_devil)

func get_entrances() -> Array:
	return $Entries.get_children()

func get_exits() -> Array:
	return $Exits.get_children()

func _on_enter_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		extend_platform()
		
		# Switch parallax background, janky but whatever
		$"../../ParallaxBackground".switch_background($"../../ParallaxBackground".possible_background.DESERT)
		
		# Ts janky ahh hell but who gaf
		$"../../../Main".reset_barrier()
	
func extend_platform():
	if not platform_extended:
		var tween = create_tween()
		tween.tween_property($Platform, "global_position:x", $Platform.global_position.x + 400, 0.25)
		platform_extended = true

func retract_platform():
	if platform_extended:
		$Platform.global_position.x = -400
		platform_extended = false
	
func _on_fall_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		if body.falling:
			$"../../ParallaxBackground".switch_background($"../../ParallaxBackground".possible_background.FOREST)

# Start dust devil logic
func _on_start_dust_devil_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		if not body.falling:
			start_devil.emit()
