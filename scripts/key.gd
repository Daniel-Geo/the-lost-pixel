extends Node2D

@onready var game_manager: Node2D = %GameManager
@onready var key_label: Label = $KeyLabel
@onready var sprite: Sprite2D = $Sprite2D

@export var req_coins:int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if game_manager.score >= req_coins:
		game_manager.has_key = true
		sprite.hide()
	else:
		key_label.show()
