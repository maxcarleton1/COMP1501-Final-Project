extends Area2D

var in_range := false
var is_open := false
@export var text: String = "This is a placeholder, change this shit bro!!"

func _ready():
	$PanelContainer.modulate.a = 0
	if GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE:
		$PanelContainer/Label.text = "HAHAHAHAHAHA"
	else:
		$PanelContainer/Label.text = text

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		in_range = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		in_range = false
		close()

func _input(event: InputEvent):
	if event.is_action_pressed("Interact") and in_range:
		if not is_open:
			open()
		else:
			close()
		
func open():
	is_open = true
	var tween = create_tween()
	tween.tween_property($PanelContainer, "modulate:a", 1, 0.5)
	
func close():
	is_open = false
	var tween = create_tween()
	tween.tween_property($PanelContainer, "modulate:a", 0, 0.25)
