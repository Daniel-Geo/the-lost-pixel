extends Node2D

var traveled_distance = 0

func _physics_process(delta: float) -> void:
	const SPEED = 200.0
	const RANGE = 1200.0
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	traveled_distance += SPEED * delta
	if traveled_distance > RANGE:
		queue_free()
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
	var enemy = area.get_parent()
	if enemy.has_method("take_damage"):
		enemy.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
	
