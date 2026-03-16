extends Area2D

#should the spike to handle the damage detection
#@export var damage := 1

func _ready() -> void:
	add_to_group("Obstacles")

func _on_area_entered(area: Area2D) -> void:
	#if area.has_method("take_damage"):
		#area.take_damage(damage)
	print("Damage Detected")
