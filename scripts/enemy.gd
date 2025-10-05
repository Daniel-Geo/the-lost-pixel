extends Node2D


const SPEED = 60.0
var direction_right = 1

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight

func _process(delta: float) -> void:
	animation.play("move")
	position.x += direction_right * SPEED * delta

	if ray_cast_left.is_colliding() or !ray_cast_down_left.is_colliding():
		animation.flip_h = false
		direction_right = 1
	elif ray_cast_right.is_colliding() or !ray_cast_down_right.is_colliding():
		animation.flip_h = true
		direction_right = -1
