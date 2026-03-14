extends Control

@onready var shop_window = $PanelContainer/MarginContainer/VBoxContainer/EconomyPage/ShopWindow

var item_list: Array[ItemData] = [
	preload("res://assets/resources/economy/item/jump_boost.tres"),
]
var upgrade_list: Array[ItemData] = [
	preload("res://assets/resources/economy/upgrade/sprint_speed.tres")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(shop_window)
	shop_window.shop_item_selected.connect(item_selected)
	display_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func item_selected(item: ItemData) -> void:
	match item.item_type:
		ItemData.ItemType.ITEM:
			purchase_item(item)
		ItemData.ItemType.UPGRADE:
			upgrade_item(item)
		_:
			print("Error")
			
func purchase_item(item: ItemData):
	print("Purchase item: " + item.name)
	pass
	
func upgrade_item(item: ItemData):
	print("Upgrade item: " + item.name)
	pass
	
func display_items() -> void:
	shop_window.create_items(item_list)

func display_upgrades() -> void:
	shop_window.create_items(upgrade_list)
	
#func setup_items_array() -> void:
	#pass
	#
#func setup_upgrades_array() -> void:
	#pass

func _on_items_pressed() -> void:
	display_items()

func _on_upgrades_pressed() -> void:
	display_upgrades()
