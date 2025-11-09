extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Engine.time_scale = 0.5
		body.get_node("HurtSFX").play()
		body.explosion_particles.emitting = true
		body.get_node("CollisionShape2D").queue_free()
		body.get_node("KillTimer").start()
