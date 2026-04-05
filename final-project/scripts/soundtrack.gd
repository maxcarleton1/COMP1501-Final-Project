extends Node

var fade_time: float = 0.5
var default_volume_db: float = 0.0
var silent_db: float = -40.0

var current_track: AudioStreamPlayer = null

# --- Track references ---
@onready var tracks := {
	"menu": $Menu,
	"green": $Green,
	"sand": $Sand,
	"snow": $Snow
}

func _ready() -> void:
	for t in tracks.values():
		t.stop()
		t.volume_db = silent_db

func change_music(name: String) -> void:
	if not tracks.has(name):
		return

	var new_track: AudioStreamPlayer = tracks[name]

	# Do nothing if already playing
	if current_track == new_track:
		return

	# Fade out current
	if current_track:
		_fade_out(current_track)

	# Switch + fade in new
	current_track = new_track
	current_track.volume_db = silent_db
	current_track.play(0.0)
	_fade_in(current_track)

func _fade_in(p: AudioStreamPlayer) -> void:
	var tween := create_tween()
	tween.tween_property(p, "volume_db", default_volume_db, fade_time)

func _fade_out(p: AudioStreamPlayer) -> void:
	var tween := create_tween()
	tween.tween_property(p, "volume_db", silent_db, fade_time)
	tween.tween_callback(p.stop)
