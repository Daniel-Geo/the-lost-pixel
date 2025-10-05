extends Node2D

@onready var game_manager: Node2D = $"../GameManager"

func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("collect")
	game_manager.add_point()
