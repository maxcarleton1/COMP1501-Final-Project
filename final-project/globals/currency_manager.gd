extends Node

signal coins_update(value: int)

var coins: int = 0

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

func clear_coins():
	set_total_coin_amount(0)
