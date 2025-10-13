extends Node

var scene
var past_scene

@onready var game_music: AudioStreamPlayer = $GameMusic
@onready var menu_music: AudioStreamPlayer = $MenuMusic

func _process(delta: float) -> void:
	if get_tree().current_scene:
		scene = get_tree().current_scene.name
		change_music()

func change_music():	
	if scene == "MainMenu" and past_scene != "MainMenu":
		stop_all_audio()
		menu_music.play()
		past_scene = "MainMenu"
		
	elif scene == "ControlMenu" and past_scene != "ControlMenu":
		stop_all_audio()
		menu_music.play()
		past_scene = "ControlMenu"
		
	elif scene == "Level1" and past_scene != "Level1":
		stop_all_audio()
		game_music.play()
		past_scene = "Level1"
		
	elif scene == "Level2" and past_scene != "Level2":
		stop_all_audio()
		game_music.play()
		past_scene = "Level2"
		
func stop_all_audio():
	for node in get_tree().get_nodes_in_group("Music"):
		node.stop()
		
