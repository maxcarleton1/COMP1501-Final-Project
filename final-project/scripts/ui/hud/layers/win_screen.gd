extends PanelContainer

func _ready():
	hide()

func update():
	$"../TimerLayer".started = false
	if GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE:
		$VBoxContainer/Title.text = "How the HELL did you do that!?"
		$VBoxContainer/Label.text = "You're probably the only person who's ever beaten this mode. \n You completed the game in: " + time_to_str($"../TimerLayer".current_time)
	else:
		$VBoxContainer/Title.text = "Congratulations!"
		$VBoxContainer/Label.text = "You completed the game in: " + time_to_str($"../TimerLayer".current_time) + "\n Now try another difficulty..."

func time_to_str(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
