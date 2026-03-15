#class_name CurrencyManager
extends Node

signal coins_update(value: int)

var coins: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_coin_amount():
	return coins
	
func set_total_coin_amount(value: int):
	coins = value
	coins_update.emit(coins)

func remove_coins(amount: int) -> bool:
	if(amount > coins):
		return false
	set_total_coin_amount(coins - amount)
	return true
	
func add_coins(amount: int):
	set_total_coin_amount(coins + amount)
