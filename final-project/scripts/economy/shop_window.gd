extends Control

signal shop_item_selected(item: ItemData)

@onready var item_list = $MarginContainer/ScrollContainer/VBoxContainer/ItemList

#Storing the individual items here
var list_item_scene = preload("res://scenes/economy/list_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(item_list)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_items(items: Array[ItemData]):
	
	for child in item_list.get_children():
		child.queue_free()
	
	for item in items:
		var newSceneItem = list_item_scene.instantiate()
		item_list.add_child(newSceneItem)
		newSceneItem.setItem(item)
		newSceneItem.item_selected.connect(_on_select_button_pressed)
		
func _on_select_button_pressed(item: ItemData):
	shop_item_selected.emit(item) 
