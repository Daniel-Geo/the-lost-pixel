extends RigidBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_layer = 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		collision_layer = 2
