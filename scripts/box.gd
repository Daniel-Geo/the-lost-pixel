extends RigidBody2D

func _physics_process(delta: float) -> void:
	linear_velocity += get_gravity() * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_layer = 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		collision_layer = 2
