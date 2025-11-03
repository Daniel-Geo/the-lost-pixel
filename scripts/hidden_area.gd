extends Area2D

var parent

@export var fade_time: float
@export var modulate_fade: float

func _ready() -> void:
	parent = self.get_parent()
	if parent:
		parent.modulate.a = 0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		for i in range(10):
			parent.modulate.a += 0.1
			await get_tree().create_timer(0.05).timeout


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		for i in range(1 / modulate_fade):
			parent.modulate.a -= modulate_fade
			await get_tree().create_timer(fade_time).timeout
