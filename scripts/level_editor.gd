extends Node2D

@export var camera: Camera2D
@export var player: CharacterBody2D

@onready var play_button: Button = $CanvasLayer/VBoxContainer/PlayButton
@onready var back_button: Button = $CanvasLayer/VBoxContainer/BackButton


const PLAYER_POS = Vector2(0, -4)

var playing := false


func _ready() -> void:
	player.process_mode = Node.PROCESS_MODE_DISABLED
	player.get_node("Camera2D").limit_bottom = 10000000

func _process(delta: float) -> void:
	if !playing:
		if Input.is_action_pressed("left"):
			camera.position.x -= 1
		if Input.is_action_pressed("right"):
			camera.position.x += 1
		if Input.is_action_pressed("jump"):
			camera.position.y -= 1
		if Input.is_action_pressed("down"):
			camera.position.y += 1


func _on_play_button_pressed() -> void:
	if playing == false:
		camera.enabled = false
		player.process_mode = Node.PROCESS_MODE_INHERIT
		player.get_node("Camera2D").enabled = true
		play_button.text = "Edit"
		play_button.release_focus()
		playing = true
	else:
		player.position = PLAYER_POS
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.get_node("Camera2D").enabled = false
		camera.enabled = true
		play_button.text = "Play"
		play_button.release_focus()
		playing = false


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
