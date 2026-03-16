extends Node2D

var speedModifier := 0

var dashSpeedModifier := 1000
	
var hardHat := false


var items := []

func addItem(item: ItemData):
	items.append(item)
func addUpgrade(item:ItemData):
	setUpgradeEffect(item)

func clearItems():
	items.clear()
func clearUpgrades():
	speedModifier = 0
	dashSpeedModifier = 0
	hardHat = false
	
func setUpgradeEffect(item:ItemData):
	match item.name:
		"Speed Boost":
			speedModifier += 100
		"Dash Boost":
			dashSpeedModifier += 100
		"Hard Hat":
			hardHat = true
		_:
			print("Error")
