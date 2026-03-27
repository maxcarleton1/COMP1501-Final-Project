extends Resource
class_name DifficultyConfig

# Area 1
@export var barrier_speed: int = 100

# Area 2
@export var dust_devil_cooldown: float = 7 # Time between warning signals, in seconds
@export var dust_devil_timer: float = 1 # How long the vortex lasts, in seconds
@export var dust_devil_width_scale: float = 1 # For collision hitbox and sprite

@export var sand_blaster_cooldown: float = 5 # Time between attacks

# Number of rooms to generate per area, -1 means all
# Could cause issues, might be better to leave it for now
# @export var rooms_per_area: int

# Whatever fun stuff to put here...
