extends Node2D

signal inventory_updated

var speedModifier := 0
var dashSpeedModifier := 0	
var hardHat := false

var HOTBAR_SIZE = 5;

#Inventory items and the hotbar slots
var items := []
var itemCount := 0

func _ready() -> void:
	print("Inventory manager ready ran")
	create_hotbar()

func print_items():
	for i in range(itemCount):
		print("Item ", i, ":", items[i])

func create_hotbar():
	#Size and fill null originally
	items.resize(HOTBAR_SIZE)
	fillNull()
	inventory_updated.emit()
	
func fillNull():
	items.fill(null)
	
func set_hotbar_slot(item: ItemData, index: int) -> bool:
	
	#Check index positions 
	if(index < -1 || index >= items.size()):
		return false
	
	##Check size before setting
	#if(itemCount + 1 > HOTBAR_SIZE):
		#return false
	items[index] = item
	itemCount = itemCount + 1 #Using a count since setting null elements in array to empty slot initialization
	inventory_updated.emit()
	print("Inventory updated signal emitted in add hotbar slot end")
	return true
	
func get_hotbar_slot(index: int):
	if(index < 0 || index > HOTBAR_SIZE):
		return -1
	return items.get(index)

func add_hotbar_slot_end(item: ItemData):
	set_hotbar_slot(item, itemCount)

func addItem(item: ItemData):
	add_hotbar_slot_end(item)
	
func addUpgrade(item:ItemData):
	setUpgradeEffect(item)

func clearItems():
	items.clear()
	create_hotbar() #Needed or just fillNull()?
	itemCount = 0
	
func clearUpgrades():
	speedModifier = 0
	dashSpeedModifier = 0
	hardHat = false
	
func setUpgradeEffect(item:ItemData):
	match item.name:
		"Speed Boost":
			speedModifier += 100
		"Dash Boost":
			dashSpeedModifier += 100
		"Hard Hat":
			hardHat = true
		_:
			print("Error")
