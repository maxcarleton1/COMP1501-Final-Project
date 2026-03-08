#Can modify size in editor
extends Node2D

@export var trigger_size: Vector2 = Vector2(200, 120)
@onready var ground := get_parent().get_node("TileMapLayer")
@onready var ray = $RayCast2D
@export var speed = 160.0
var current_speed = 0.0
#@export var damage := 1

@onready var trigger_area: Area2D = $Trigger
@onready var hitbox_area: Area2D = $HitBox
@onready var trigger_shape: CollisionShape2D = $Trigger/CollisionShape2D

func _ready():
	trigger_area.body_entered.connect(_on_trigger_area_entered)
	hitbox_area.body_entered.connect(_on_hitbox_area_entered)
	
	var rect = trigger_shape.shape as RectangleShape2D
	rect.size = trigger_size
	trigger_shape.position = Vector2(0, trigger_size.y / 2)

func _physics_process(delta: float) -> void:
	if current_speed != 0:
		position.y += current_speed * delta
		if ray.is_colliding():
			current_speed = 0
			print("Hit Ground")
			await get_tree().create_timer(2).timeout
			queue_free()

func _on_trigger_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("fall triggered")
		fall()

func _on_hitbox_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Damage Detected")
		# body.take_damage(damage)
		queue_free()

func fall():
	current_speed = speed
	print("falling")
