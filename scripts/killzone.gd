extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	body.get_node("HurtSFX").play()
	body.get_node("CollisionShape2D").queue_free()
	body.get_node("KillTimer").start()
