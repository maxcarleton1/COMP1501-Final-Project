extends Node2D

signal win_hitbox

func _ready():
	$FireworkTrail.emitting = false
	$FireworkBoom.emitting = false

func get_entry_pos() -> Vector2:
	return $Entry.global_position

# This is a janky fix to place the end room at the right position on regenerate()
func get_entry_pos_difference() -> Vector2:
	return $Entry.global_position - global_position

func _on_win_hitbox_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		win_hitbox.emit()
	
		$FireworkTrail.emitting = true
		
		# Stop coldness
		body.cold_manager.temp = 20
		body.cold_manager.coldness = 0
		
		# Show victory screen, jank central
		$"../../HUD/WinScreen".update()
		$"../../HUD/WinScreen".show()
		$"../../HUD/WinScreen/VBoxContainer/Button".grab_focus()
