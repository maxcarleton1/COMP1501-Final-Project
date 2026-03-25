extends Node2D

class InventorySlot:
	var item: ItemData = null
	var quantity: int = 0


signal inventory_updated 

signal selected_hotbar_index_updated(index: int)

#Set default selection at beginning
var selected_hotbar_index: int = 0

signal item_used(item: ItemData, index: int)

var speedModifier := 0
var dashSpeedModifier := 0	
var hardHat := false

var HOTBAR_SIZE : int = 5;

#Inventory item hotbar slots
var items : Array[InventorySlot]= []

func _ready() -> void:
	create_hotbar()

func create_hotbar():
	items.clear()
	for i in range(HOTBAR_SIZE):
		items.append(InventorySlot.new())
	inventory_updated.emit()
	
func set_hotbar_slot(item: ItemData, index: int, quantity: int = 1) -> bool:
	#Check index positions 
	if(index < 0 || index >= items.size()):
		return false
	items[index].item = item
	items[index].quantity = quantity
	inventory_updated.emit()
	return true
	
func get_hotbar_slot(index: int):
	if(index < 0 || index >= HOTBAR_SIZE):
		return -1
	return items.get(index)

func add_hotbar_slot_end(item: ItemData):
	
	#If existing slot, add to it
	for i in range(items.size()):
		if items[i].item != null and items[i].item == item:
			items[i].quantity += 1
			inventory_updated.emit()
			return true
			
	#No existing slot, make new one 
	for i in range(items.size()):
		if items[i].item == null:
			#Emits in function here here
			set_hotbar_slot(item, i)
			return true
			
	print("Hotbar full, cannot add to end")
	return false

func addItem(item: ItemData):
	add_hotbar_slot_end(item)
	
func addUpgrade(item:ItemData):
	setUpgradeEffect(item)

func clearItems():
	#Clears before creating new hotbar
	create_hotbar()
	
func clearUpgrades():
	speedModifier = 0
	dashSpeedModifier = 0
	hardHat = false
	
func setUpgradeEffect(item:ItemData):
	match item.name:
		"Speed Boost":
			speedModifier += 100
			print(speedModifier)
		"Dash Boost":
			dashSpeedModifier += 100
		"Hard Hat":
			hardHat = true
		_:
			print("Error")
			
func select_hotbar_slot(index: int):
	
	if(index < 0 || index > HOTBAR_SIZE):
		return
	
	selected_hotbar_index = index
	selected_hotbar_index_updated.emit(index)
	
func use_selected_item():
	if(selected_hotbar_index < 0 || selected_hotbar_index >= items.size()):
		return
	
	var item_slot = items[selected_hotbar_index]
	
	if(	item_slot == null ||
	 	item_slot.item == null ||
	 	item_slot.quantity <= 0):
		return
	
	var used_item = item_slot.item
	use_item_logic(used_item)
	item_slot.quantity -= 1
	
	if(item_slot.quantity <= 0):
		item_slot.item = null
		item_slot.quantity = 0
		
	inventory_updated.emit()
	item_used.emit(item_slot.item, selected_hotbar_index)
	
func use_item_logic(item: ItemData):
	print("Used item logic: ", item.name)
	
