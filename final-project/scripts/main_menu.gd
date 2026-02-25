extends Control

@export var mainGame: PackedScene 

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(mainGame)
