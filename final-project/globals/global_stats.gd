extends Node

# Should only put important stuff here!
enum difficulty {EASY, NORMAL, HARD, HELL_MODE}

var current_difficulty := difficulty.NORMAL
var barrier_speed := 100

# Keeps track of the highest point reached per run, gets updated by the AltitudeTracker scene
var best_altitude: int 
