extends Area2D

var blast_force := 1100
var can_explode := true

func _ready() -> void:
	$ExplosionSprite.hide()
	$ExplosionParticles.emitting = false
	$RegenParticles.emitting = false

func explode():
	can_explode = false
	$Sprite2D.hide()
	$ExplosionSprite.show()
	$ExplosionSprite.play("default")
	$ExplosionParticles.emitting = true

	$ExplosionRadius/CollisionShape2D.set_deferred("disabled", false)
	$VisionRadius.set_deferred("disabled", true)
	
	# Explosion should only be active for a tiny moment
	await $ExplosionSprite.animation_finished
	$ExplosionSprite.hide()
	$ExplosionRadius/CollisionShape2D.set_deferred("disabled", true)
	
	$PreRegenTimer.start()
	
# Same as regular behaviour
func blast_behaviour():
	explode()

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		if not body.falling:
			explode()

func _on_pre_regen_timer_timeout():
	$RegenParticles.emitting = true
	$RegenTimer.start()

func _on_regen_timer_timeout():
	$RegenParticles.emitting = false
	$Sprite2D.modulate.a = 0 # Start invisible
	$Sprite2D.show()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 1, 1)
	$VisionRadius.set_deferred("disabled", false)

func _on_explosion_radius_body_entered(body: Node2D):
	if body.is_in_group("Player") or body.is_in_group("InteractiveObstacle"):
		var direction_to_body = body.global_position - global_position
		direction_to_body = direction_to_body.normalized()
		
		if body.is_in_group("Player"):
			if body.falling: # Hopefully prevents weird falling explosion interactions
				return
			body.is_jump_velocity = false
			
		body.velocity = direction_to_body * blast_force
		
		# Call unique behaviour
		if body.is_in_group("InteractiveObstacle"):
			body.blast_behaviour()
