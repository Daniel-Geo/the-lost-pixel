extends Node2D

@export var item: String
@export var next_scene:String

@onready var game_manager: Node2D = %GameManager
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var win_label: Label = $WinLabel
@onready var lose_label: Label = $LoseLabel
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	lose_label.hide()
	win_label.hide()
	sprite_2d.hide()
	if get_tree().current_scene.name == "Level6":
		win_label.text = "You win\nYou assembled " + item
	else:
		win_label.text += " " + item

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if game_manager.has_key:
			var music_bus_index = AudioServer.get_bus_index("Music")
			AudioServer.set_bus_mute(music_bus_index, true)
			var sfx_bus_index = AudioServer.get_bus_index("SFX")
			AudioServer.set_bus_volume_db(sfx_bus_index, 12)
			
			collision_shape_2d.queue_free()
			lose_label.hide()
			win_label.show()
			sprite_2d.show()
			animation.play("opened")
			audio_player.play()
			Engine.time_scale = 0.5
			await get_tree().create_timer(2).timeout
			Engine.time_scale = 1
			AudioServer.set_bus_mute(music_bus_index, false)
			AudioServer.set_bus_volume_db(sfx_bus_index, 6)
			get_tree().change_scene_to_file("res://scenes/" + next_scene + ".tscn")
					
		else:
			lose_label.show()
