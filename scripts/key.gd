extends Node2D

@onready var game_manager: Node2D = $"../GameManager"
@onready var key_label: Label = $KeyLabel
@onready var sprite: Sprite2D = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if game_manager.score >= 6:
		game_manager.has_key = true
		sprite.hide()
	else:
		key_label.show()
