extends Button

var tween: Tween = null
@onready var hover_sound = $Hover
@onready var click_sound = $Click

func _on_mouse_entered() -> void:
	
	var random_rotation = randf_range(-3.0, 3.0)
	
	tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self , "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(self , "rotation_degrees", random_rotation, 0.2)
	
	hover_sound.play()

func _on_mouse_exited() -> void:
	tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self , "scale", Vector2.ONE, 0.2)
	tween.tween_property(self , "rotation_degrees", 0.0, 0.2)

func _on_pressed() -> void:
	click_sound.play()
