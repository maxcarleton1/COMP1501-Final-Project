extends Node2D

var coldness := 0
var temp := 0
@onready var snow = $Snow
func _on_timer_timeout() -> void:
	if coldness <0:
		coldness += temp/2
	elif temp <0:
		coldness += temp/2
	$TextureProgressBar.value = coldness*-1
	if coldness < -100 and not get_parent().falling:
		get_parent().fall()

func _process(delta: float) -> void:
	if GlobalStats.current_difficulty == GlobalStats.difficulty.HELL_MODE:
		if temp <= 0:
			if $Hotboy.playing:
				$Hotboy.stop()
			if coldness <= -100 and not $PGnot13.playing:
				$PGnot13.play()
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
			
			
