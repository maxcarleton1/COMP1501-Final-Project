extends Resource
class_name AreaSet

# A simple class which stores all the areas we want to load in the run.
@export var room_sets: Array[Area]

# AreaSets probably shouldn't have randomized order, for progression purposes



# Idea 1: Array
# - AreaSet contains Areas, which contain Rooms
# - Configure Areas to have order?
