extends Node

# Should only put important stuff here!

enum difficulty {NORMAL, HARD, HELL_MODE}
var current_difficulty := difficulty.NORMAL

# For setting stats across the game per difficulty, it's janky but whatev
var easy_data := preload("res://assets/resources/difficulty/normal.tres")
var normal_data := preload("res://assets/resources/difficulty/hard.tres")
var hard_data := preload("res://assets/resources/difficulty/hell_mode.tres")

var difficulty_data: DifficultyConfig

func _ready():
	_update_difficulty_data()

func _update_difficulty_data():
	match current_difficulty:
		difficulty.NORMAL:
			difficulty_data = easy_data
		difficulty.HARD:
			difficulty_data = normal_data
		difficulty.HELL_MODE:
			difficulty_data = hard_data

# Helpers for buttons
func cycle_difficulty():
	current_difficulty = (current_difficulty + 1) % difficulty.size()
	_update_difficulty_data()

func dif_to_str(dif: difficulty):
	if dif == difficulty.NORMAL:
		return "Normal"
	if dif == difficulty.HARD:
		return "Hard!"
	if dif == difficulty.HELL_MODE:
		return "HELL MODE!!!"

# Keeps track of the highest point reached per run, gets updated by the AltitudeTracker scene
var best_altitude: float 
