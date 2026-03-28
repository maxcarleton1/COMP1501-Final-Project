extends Resource

class_name ItemData

enum ItemType { ITEM, UPGRADE, CURRENCY }

enum ItemEffect {
	FEATHER_FALLING,
	JUMP_BOOST,
	NONE
}

@export var name: String
@export var description: String
@export var price: int
@export var icon: Texture2D
@export var item_type: ItemType
@export var max_amount: int = -1
@export var seconds: int = 0
@export var item_effect: ItemEffect = ItemEffect.NONE
