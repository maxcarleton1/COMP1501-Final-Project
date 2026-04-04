extends Node2D

# When player enters start barrier, make sure they don't fall back down
# Extend platform so the bottom is closed
# Change parallax background and re-center it
# Disable lava rising (send signal to main?)

var platform_extended := true

func _ready():
	if not has_node("Entries"):
		push_error("Missing required child node: Entries")
	if not has_node("Exits"):
		push_error("Missing required child node: Exits")
		
	retract_platform()

func get_entrances() -> Array:
	return $Entries.get_children()

func get_exits() -> Array:
	return $Exits.get_children()

func _on_enter_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		extend_platform()
		body.cold_manager.temp = -10
		body.cold_manager.snow.emitting = true
		# Switch parallax background, janky but whatever
		$"../../ParallaxBackground".switch_background($"../../ParallaxBackground".possible_background.SNOW)
		
		# Stop dust devil
		$"../../../Main".reset_dust_devil()
		
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
			$"../../ParallaxBackground".switch_background($"../../ParallaxBackground".possible_background.DESERT)
			body.cold_manager.snow.emitting = false
			body.cold_manager.temp = 0
			body.cold_manager.coldness = 0
