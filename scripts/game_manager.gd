extends Node2D

var score = 0
var has_key = false
var acuired_spell = false

@export var score_label: Label

func _ready() -> void:
	if get_tree().current_scene:
		if get_tree().current_scene.name == "Level2":
			GameManager.acuired_spell = true

func add_point():
	score += 1
	score_label.text = "Coins x" + str(score)
	
