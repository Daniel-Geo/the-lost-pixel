extends Node2D

@export var distance = 64.0
@export var move_time = 4.0
@export var wait_time = 0.5

var start_pos: Vector2
var end_pos: Vector2
var target
var moving_to_end = true
var waiting = false

func _ready() -> void:
	start_pos = position
	end_pos = start_pos + (Vector2(0, -distance))
	
func _process(delta: float) -> void:
	if waiting:
		return
		
	if moving_to_end:
		target = end_pos
	else:
		target = start_pos
	
	var speed = distance / move_time
	position = position.move_toward(target, speed * delta)
	
	if position.distance_to(target) < 1.0:
		on_reach_point()
		

func on_reach_point():
	moving_to_end = not moving_to_end
	waiting = true
	await get_tree().create_timer(wait_time).timeout
	waiting = false
	
