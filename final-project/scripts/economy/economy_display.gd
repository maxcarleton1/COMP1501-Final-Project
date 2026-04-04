extends Control

@onready var shop_window = $PanelContainer/MarginContainer/VBoxContainer/EconomyPage/ShopWindow

var item_list: Array[ItemData] = [
	preload("res://assets/resources/economy/item/balloon.tres"),
	preload("res://assets/resources/economy/item/balloon_golden.tres"),
	preload("res://assets/resources/economy/item/feather_falling.tres"),
	preload("res://assets/resources/economy/item/feather_falling_golden.tres"),
]
var upgrade_list: Array[ItemData] = [
	preload("res://assets/resources/economy/upgrade/speed_boost.tres")
]

func _ready() -> void:
	shop_window.shop_item_selected.connect(item_selected)
	display_items()

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
	if(CurrencyManager.remove_coins(item.price)):
		add_item_to_inventory(item)
	else: 
		print("Not enough coins")
	
func upgrade_item(item: ItemData):
	print("Upgrade item: " + item.name)
	if(CurrencyManager.remove_coins(item.price)):
		add_upgrade_to_inventory(item)
	else: 
		print("Not enough coins")
		
func add_item_to_inventory(item: ItemData):
	#print("Success: Item inventory logic goes here: " + item.name)
	InventoryManager.addItem(item)

func add_upgrade_to_inventory(item: ItemData):
	#print("Success: Upgrade item: " + item.name)
	InventoryManager.addUpgrade(item)

func display_items() -> void:
	shop_window.create_items(item_list)

func display_upgrades() -> void:
	shop_window.create_items(upgrade_list)

func _on_items_pressed() -> void:
	display_items()

#To re-add upgrades, add button named "Upgrades" to HBoxContainerButtons
#func _on_upgrades_pressed() -> void:
	#display_upgrades()
	
func open_economy_display():
	show()

func close_economy_display():
	hide()
	
func toggle_economy_display():
	if (visible):
		close_economy_display()
	else:
		open_economy_display()
	
func _on_exit_pressed() -> void:
	close_economy_display()
