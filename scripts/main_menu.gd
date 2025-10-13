extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")


func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
