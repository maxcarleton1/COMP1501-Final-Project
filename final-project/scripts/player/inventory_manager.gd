extends Node2D

var speedModifyer = 0
var dashBoost = 0
var hardHat = false

var items := []
func addItem(item: ItemData):
	items.append(item)
func addUpgrade(item:ItemData):
	setUpgradeEffect(item)

func clearItems():
	items.clear()
func clearUpgrades():
	speedModifyer = 0
	dashBoost = 0
	hardHat = false
func setUpgradeEffect(item:ItemData):
	match item.name:
		"Speed Boost":
			speedModifyer += 100
		"Dash Boost":
			dashBoost += 100
		"Hard Hat":
			hardHat = true
		_:
			print("Error")
