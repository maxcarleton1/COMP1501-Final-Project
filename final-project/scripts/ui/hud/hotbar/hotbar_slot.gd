extends Panel

@onready var icon_texture = $Icon
@onready var quantity_label = $Quantity

var default_icon_not_found = preload("res://assets/art/icon.svg")

#func set_item_slot(image: TextureRect, quantity: int):
func set_item_slot(item: ItemData, quantity: int):
	
	if(item == null):
		set_item_texture(default_icon_not_found)
		set_item_quantity(0)
		return
	
	if(item.icon != null): 
		set_item_texture(item.icon)
	else: #If image not set use placeholder
		set_item_texture(default_icon_not_found)
	set_item_quantity(quantity)
	
func set_item_quantity(quantity: int):
	quantity_label.text = str(quantity)

func set_item_texture(texture: Texture2D):
	icon_texture.texture = texture

func set_selected_slot():
	#Change colour of selected for scroll / use?
	pass
