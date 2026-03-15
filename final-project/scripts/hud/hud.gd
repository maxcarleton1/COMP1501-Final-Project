extends HBoxContainer

@onready var coin_label = $CoinAmount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrencyManager.coins_update.connect(coin_update)
	coin_update(CurrencyManager.get_coin_amount())

func coin_update(value: int):
	coin_label.text = str(value)
