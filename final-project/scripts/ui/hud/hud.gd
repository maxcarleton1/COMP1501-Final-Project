extends CanvasLayer

@onready var coin_label = $MarginContainer/VBoxContainer/CurrencyLayer/CoinAmount
@onready var altitude_label = $MarginContainer/VBoxContainer/AltitudeLayer/AltitudeAmount

@onready var player := get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrencyManager.coins_update.connect(coin_update)
	coin_update(CurrencyManager.get_coin_amount())

func _process(delta) -> void:
	altitude_update(player.global_position.y * -0.01)

func coin_update(value: int):
	coin_label.text = str(value)

func altitude_update(value: float):
	altitude_label.text = "%.2fm" % (value) 
