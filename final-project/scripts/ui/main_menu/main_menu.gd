extends Control

var main_scene := preload("res://scenes/main.tscn") 

func _ready():
	$PanelContainer/PanelContainer/VBoxContainer/StartGame.grab_focus()

func _on_start_game_pressed():
	get_tree().change_scene_to_packed(main_scene)
	InventoryManager.clearItems()
	InventoryManager.clearUpgrades()
	CurrencyManager.clear_coins()

func _on_quit_pressed():
	get_tree().quit()

func _on_difficulty_pressed():
	GlobalStats.cycle_difficulty()
	$PanelContainer/PanelContainer/VBoxContainer/Difficulty.text = "Difficulty: %s" % GlobalStats.dif_to_str(GlobalStats.current_difficulty)
