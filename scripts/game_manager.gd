extends Node2D

var score = 0
var has_key = false
var acuired_spell = false
var acuired_dash = false

@onready var score_label: Label = %ScoreLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	if get_tree().current_scene:
		if get_tree().current_scene.name == "Level3":
			GameManager.acuired_dash = true
		if get_tree().current_scene.name == "Level2" or get_tree().current_scene.name == "Level3":
			GameManager.acuired_spell = true
		if get_tree().current_scene.name == "Level1":
			GameManager.acuired_spell = false

func add_point():
	score += 1
	score_label.text = "Coins x" + str(score)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
