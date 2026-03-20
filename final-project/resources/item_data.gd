extends Resource

class_name ItemData

enum ItemType { ITEM, UPGRADE, CURRENCY }

@export var name: String
@export var description: String
@export var price: int
@export var icon: Texture2D
@export var item_type: ItemType
@export var max_amount: int = -1
