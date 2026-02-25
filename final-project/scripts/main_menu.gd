extends Control

@export var mainGame: PackedScene 

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(mainGame)
