extends CanvasLayer

@onready var coin_label = $MarginContainer/VBoxContainer/CurrencyLayer/CoinAmount
@onready var altitude_label = $MarginContainer/VBoxContainer/AltitudeLayer/AltitudeAmount

@onready var player := get_tree().get_first_node_in_group("Player")

@onready var hotbar_slots = $MarginContainer/VBoxContainer/HotbarLayer/HotbarContainer.get_children()

@onready var hotbar_item_selected_name = $MarginContainer/VBoxContainer/HotbarLayer/SelectedTextContainer/ItemSelectedName
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrencyManager.coins_update.connect(coin_update)
	coin_update(CurrencyManager.get_coin_amount())
	
	InventoryManager.inventory_updated.connect(update_hotbar_slots_UI)
	update_hotbar_slots_UI()
	
	InventoryManager.selected_hotbar_index_updated.connect(update_hotbar_slot_selected)
	update_hotbar_slot_selected(InventoryManager.selected_hotbar_index)

func _process(delta) -> void:
	altitude_update(player.global_position.y * -0.01)

func coin_update(value: int):
	coin_label.text = str(value)

func altitude_update(value: float):
	altitude_label.text = "%.2fm" % (value)

func update_hotbar_slots_UI():
	for i in range(hotbar_slots.size()):
		var hotbar_slot = InventoryManager.get_hotbar_slot(i)
		hotbar_slots[i].set_item_slot(hotbar_slot.item, hotbar_slot.quantity)

func update_hotbar_slot_selected(index: int):
	for i in range(hotbar_slots.size()):
		hotbar_slots[i].set_selected_slot(index == i)
		if(index == i):
			var hotbar_slot = InventoryManager.get_hotbar_slot(i)
			if(hotbar_slot != null and hotbar_slot.item != null):
				hotbar_item_selected_name.text = hotbar_slot.item.name
			else:
				hotbar_item_selected_name.text = ""
		
	
