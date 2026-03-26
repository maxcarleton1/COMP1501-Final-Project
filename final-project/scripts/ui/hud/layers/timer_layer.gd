extends PanelContainer

var current_time: float = 0.0
var started: bool = false

# Keeps track of current time, gets reset on 
func _physics_process(delta: float):
	if started:
		current_time += delta
		$PanelContainer/CurrentTime.text = "Current time: " + time_to_str(current_time)

func time_to_str(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

# Resets on run reset, do in main
func reset():
	current_time = 0.0
	started = false

func check_best_time():
	if current_time < GlobalStats.best_time:
		GlobalStats.best_time = current_time
		$PanelContainer/BestTime.text = "Best time: " + time_to_str(current_time)
		print($PanelContainer/CurrentTime.text)
