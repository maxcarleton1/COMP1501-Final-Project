extends Node2D

signal win_hitbox

func get_entry_pos() -> Vector2:
	return $Entry.global_position

# This is a janky fix to place the end room at the right position on regenerate()
func get_entry_pos_difference() -> Vector2:
	return $Entry.global_position - global_position

func _on_win_hitbox_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		win_hitbox.emit() # Send signal to what?
	
		# Do anything else for end room specific win logic here 
