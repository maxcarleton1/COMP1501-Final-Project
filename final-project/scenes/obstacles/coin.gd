extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	CurrencyManager.add_coins(1)
	queue_free()
