extends Node2D

@onready var game_manager: Node2D = %GameManager
@onready var key_label: Label = $KeyLabel

@export var req_coins:int

func _ready() -> void:
	key_label.text = "You need " + str(req_coins) + " coins
to buy the key"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if game_manager.score >= req_coins:
		game_manager.has_key = true
		queue_free()
	else:
		key_label.show()
