extends Resource
class_name DifficultyConfig

# Player stun, replaced with instakill in hell mode
@export var player_stun_duration: int = 1 # In seconds

# Area 1
@export var barrier_speed: int = 100

# Area 2
@export var dust_devil_cooldown: float = 7 # Time between warning signals, in seconds
@export var dust_devil_timer: float = 1 # How long the vortex lasts, in seconds
@export var dust_devil_width_scale: float = 1 # For collision hitbox and sprite

@export var sand_blaster_cooldown: float = 5 # Time between attacks
