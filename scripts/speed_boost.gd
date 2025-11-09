extends Node2D

var speed_factor = 1.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.speed *= speed_factor
		$AnimationPlayer.play("collect")
		await get_tree().create_timer(5).timeout
		body.speed /= speed_factor
		queue_free()
