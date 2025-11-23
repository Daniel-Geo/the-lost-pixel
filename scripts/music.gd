extends Node

var scene
var past_scene

@onready var game_music: AudioStreamPlayer = $GameMusic
@onready var level_4_music: AudioStreamPlayer = $Level4Music
@onready var level_5_music: AudioStreamPlayer = $Level5Music
@onready var space_levels_music: AudioStreamPlayer = $SpaceLevelsMusic
@onready var editor_music: AudioStreamPlayer = $EditorMusic
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
		
	elif scene == "LevelEditor" and past_scene != "LevelEditor":
		stop_all_audio()
		editor_music.play()
		past_scene = "LevelEditor"
		
	elif scene == "Level1" and past_scene != "Level1":
		stop_all_audio()
		game_music.play()
		past_scene = "Level1"
		
	elif scene == "Level2" and past_scene != "Level2":
		stop_all_audio()
		game_music.play()
		past_scene = "Level2"
	
	elif scene == "Level3" and past_scene != "Level3":
		stop_all_audio()
		game_music.play()
		past_scene = "Level3"
		
	elif scene == "Level4" and past_scene != "Level4":
		stop_all_audio()
		level_4_music.play()
		past_scene = "Level4"
		
	elif scene == "Level5" and past_scene != "Level5":
		stop_all_audio()
		level_5_music.play()
		past_scene = "Level5"
		
	elif scene == "Level6" and past_scene != "Level6":
		stop_all_audio()
		space_levels_music.play()
		past_scene = "Level6"
	elif scene == "Level7" and past_scene != "Level7":
		stop_all_audio()
		space_levels_music.play()
		past_scene = "Level7"
		
func stop_all_audio():
	for node in get_tree().get_nodes_in_group("Music"):
		node.stop()
