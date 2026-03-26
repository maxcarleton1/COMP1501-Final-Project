extends RigidBody2D

# Collision shouldn't interact with player, should interact with just about everything else
# Using collision layer/mask 3

# Should be heavy and hard to move (?)
# Gets more affected by gravity (gravity scale)

var blast_force := 1250

func _ready() -> void:
	$Explosion/CollisionShape2D.set_deferred("disabled", true)
	$ExplosionSprite.hide()
	$GPUParticles2D.emitting = false

func _input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		if not get_tree().get_first_node_in_group("Player").falling:
			explode()

func explode():
	$ExplosionSprite.show()
	$ExplosionSprite.play("default")
	$GPUParticles2D.emitting = true
	# Blast logic
	# 1. Show/create area2D with larger circular collision hitbox
	# 2. Get all applicable bodies inside the radius (player, whatever mobs)
	# 3. Get the vector from this to the body (body.global_position - global_position)
	# 4. For each body, add that vector * multiplier to that body's velocity
	# 5. OPTIONAL: make multiplier drop off based on distance from this global_position
	$Explosion/CollisionShape2D.set_deferred("disabled", false) # Then wait for Area2D signal
	
	# SFX
	$Sound.play()
	
	# Explosion should only be active for a tiny moment
	await $ExplosionSprite.animation_finished
	$Explosion/CollisionShape2D.set_deferred("disabled", true)
	
	# Wait for stuff to finish before deleting
	queue_free()
	
func _on_explosion_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		var direction_to_body = body.global_position - global_position
		direction_to_body = direction_to_body.normalized()
		
		body.velocity = direction_to_body * blast_force
