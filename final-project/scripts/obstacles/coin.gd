extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.pickup_coin()
	CurrencyManager.add_coins(1)
	queue_free()
