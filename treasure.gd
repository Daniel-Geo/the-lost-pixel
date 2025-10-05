extends Node2D

@onready var game_manager: Node2D = $"../GameManager"
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var win_label: Label = $WinLabel
@onready var lose_label: Label = $LoseLabel
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if game_manager.has_key:
		var bus_index = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_mute(bus_index, true)
		bus_index = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(bus_index, 12)
		
		collision_shape_2d.queue_free()
		lose_label.hide()
		win_label.show()
		animation.play("opened")
		audio_player.play()
	else:
		lose_label.show()
