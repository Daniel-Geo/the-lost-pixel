extends Control

var music_bus_index = AudioServer.get_bus_index("Music")

func _ready() -> void:
	get_tree().paused = false
	visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()

func resume():
	get_tree().paused = false
	visible = false

func pause():
	get_tree().paused = true
	visible = true
	

func _on_resume_button_pressed() -> void:
	resume()


func _on_restart_button_pressed() -> void:
	resume()
	AudioServer.set_bus_mute(music_bus_index, false)
	get_tree().reload_current_scene()
	


func _on_main_menu_button_pressed() -> void:
	resume()
	AudioServer.set_bus_mute(music_bus_index, false)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
