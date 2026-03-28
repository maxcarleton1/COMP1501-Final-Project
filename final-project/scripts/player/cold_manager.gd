extends Node2D

var coldness := 0
var temp := 0

func _on_timer_timeout() -> void:
	if coldness <=50:
		coldness += temp
func _process(delta: float) -> void:
	if temp <= 0:
		if $Hotboy.playing:
			$Hotboy.stop()
		if coldness <= -100 and not $PGnot13.playing:
			$PGnot13.play()
			print("g")
			if $Shiver.playing:
				$Shiver.stop()
		elif coldness <= -50 and not $Shiver.playing and not $PGnot13.playing:
			$Shiver.play()
			if $PGnot13.playing:
				$PGnot13.stop()
		elif coldness > -50:
			if $Shiver.playing:
				$Shiver.stop()
	elif temp > 0 and not $Hotboy.playing:
		$Hotboy.play()
		
		
