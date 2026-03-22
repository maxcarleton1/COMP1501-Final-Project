extends Node2D

signal economy_display_requested
signal economy_display_close_requested

var shop_in_player_range := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(shop_in_player_range and Input.is_action_just_pressed("Interact")):
		open_shop();

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		shop_in_player_range = true

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		shop_in_player_range = false
		close_shop()

func open_shop():
	economy_display_requested.emit()
	
func close_shop():
	economy_display_close_requested.emit()
