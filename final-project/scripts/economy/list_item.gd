extends PanelContainer

signal item_selected(item: ItemData)

var item: ItemData

@onready var base_path  = $MarginContainer/VBoxContainer

@onready var name_label = base_path.get_node("HBoxContainerTop/ItemName")
@onready var icon_image = base_path.get_node("HBoxContainerMiddle/ItemIcon")
@onready var price_label = base_path.get_node("HBoxContainerPrice/ItemPrice")
@onready var select_button = base_path.get_node("HBoxContainerBottom/SelectButton")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_select_button_pressed() -> void:
	item_selected.emit(item) 
	
func setItem(itemData: ItemData):
	item = itemData;
	#Setup UI
	name_label.text = itemData.name;
	icon_image.texture = itemData.icon;
	price_label.text = "$" + str(itemData.price);
	#Button text based on item type action
	setButtonText(itemData.item_type)
	
func setButtonText(item_type):
	match item_type:
		ItemData.ItemType.ITEM:
			select_button.text = "Purchase"
		ItemData.ItemType.UPGRADE:
			select_button.text = "Upgrade"
		
