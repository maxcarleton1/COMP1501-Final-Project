extends PanelContainer

var controls_str := " Movement: WASD \n Jump: Space \n Dash: Shift \n Items: 1-5 + G \n Pause Menu: Escape \n"
var bomb_str := " Movement: WASD \n Jump: Space \n Dash: Shift \n Items: 1-5 + G \n Pause Menu: Escape \n Drop/Detonate Bomb: O \n"
var grapple_str := " Movement: WASD \n Jump: Space \n Dash: Shift \n Items: 1-5 + G \n Pause Menu: Escape \n Drop/Detonate Bomb: O \n Grappling Hook: P \n"

func _ready():
	hide()
	if GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE:
		$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls.text = "HAHAHAHAHAHA"
		$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = "HAHAHAHAHAHA"
	else:
		$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls.text = "Controls"
		$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = controls_str

func _input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		if not get_tree().paused:
			show()
			get_tree().paused = true
			$VBoxContainer/HBoxContainer/VBoxContainer/Resume.grab_focus()
		else:
			hide()
			get_tree().paused = false

func _on_resume_pressed():
	hide()
	get_tree().paused = false

func _on_quit_pressed():
	get_tree().paused = false
	GlobalStats.current_difficulty = GlobalStats.difficulty.NORMAL # Fixes UI bug
	GlobalStats._update_difficulty_data()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

func unlocked(item: int = 0):
	if GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE:
		$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = "HAHAHAHAHAHA"
	else:
		if item == 1:
			$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = bomb_str
		elif item == 2:
			$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = grapple_str
		else:
			$VBoxContainer/HBoxContainer/ControlsList/VBoxContainer/Controls2.text = controls_str
