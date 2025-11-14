extends Node2D

var score: int = 0
var has_key := false

var acquired_spell := false
var acquired_dash := false
var acquired_wall_jump := false
var acquired_double_jump := false
var acquired_drop_through_platform := true
var acquired_flip_jump := false
var acquired_flip := false

@onready var score_label: Label = %ScoreLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	if get_tree().current_scene:
		if get_tree().current_scene.name == "Level5" or get_tree().current_scene.name == "Level6":
			GameManager.acquired_double_jump = true
		if get_tree().current_scene.name == "Level4" or get_tree().current_scene.name == "Level5" or get_tree().current_scene.name == "Level6":
			GameManager.acquired_wall_jump = true
		if get_tree().current_scene.name == "Level3" or get_tree().current_scene.name == "Level4" or get_tree().current_scene.name == "Level5" or get_tree().current_scene.name == "Level6":
			GameManager.acquired_dash = true
		if get_tree().current_scene.name == "Level2" or get_tree().current_scene.name == "Level3" or get_tree().current_scene.name == "Level4" or get_tree().current_scene.name == "Level5" or get_tree().current_scene.name == "Level6":
			GameManager.acquired_spell = true
		if get_tree().current_scene.name == "Level6":
			GameManager.acquired_flip_jump = true
			GameManager.acquired_double_jump = false
			GameManager.acquired_wall_jump = false
		if get_tree().current_scene.name == "Level5":
			GameManager.acquired_flip_jump = false
		if get_tree().current_scene.name == "Level4":
			GameManager.acquired_double_jump = true
			GameManager.acquired_double_jump = false
			GameManager.acquired_flip_jump = false
		if get_tree().current_scene.name == "Level3":
			GameManager.acquired_wall_jump = false
			GameManager.acquired_double_jump = false
			GameManager.acquired_flip_jump = false
		if get_tree().current_scene.name == "Level2":
			GameManager.acquired_dash = false
			GameManager.acquired_wall_jump = false
			GameManager.acquired_double_jump = false
			GameManager.acquired_flip_jump = false
		if get_tree().current_scene.name == "Level1":
			GameManager.acquired_spell = false
			GameManager.acquired_dash = false
			GameManager.acquired_wall_jump = false
			GameManager.acquired_double_jump = false
			GameManager.acquired_flip_jump = false

func add_point():
	score += 1
	score_label.text = "Coins x" + str(score)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
