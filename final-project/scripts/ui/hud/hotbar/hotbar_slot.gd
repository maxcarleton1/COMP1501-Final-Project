extends Panel

@onready var icon_texture = $Image
@onready var quantity_label = $Quantity

var default_icon_not_found = preload("res://assets/art/icon.svg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func set_item_slot(image: TextureRect, quantity: int):
func set_item_slot(item: ItemData):
	
	if(item == null):
		set_item_texture(default_icon_not_found)
		set_item_quantity(0)
		return
	#Change image, and quantity
	#Valid, set
	print("item icon testing testing testing", item.icon)
	
	if(item.icon != null): 
		set_item_texture(item.icon)
	else: #If image not set use placeholder
		set_item_texture(default_icon_not_found)
	set_item_quantity(1)
	print("testing")
	
func set_item_quantity(quantity: int):
	quantity_label = quantity

func set_item_texture(texture: Texture2D):
	icon_texture = texture

func set_selected_slot():
	#Change colour of selected for scroll / use?
	pass
