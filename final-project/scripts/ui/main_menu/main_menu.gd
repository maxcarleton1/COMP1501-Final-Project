extends Control

var main_scene := preload("res://scenes/main.tscn") 

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_difficulty_pressed() -> void:
	GlobalStats.cycle_difficulty()
	$PanelContainer/VBoxContainer/Difficulty.text = "Difficulty: %s" % GlobalStats.dif_to_str(GlobalStats.current_difficulty)
