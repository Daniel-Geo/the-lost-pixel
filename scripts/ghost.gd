extends CharacterBody2D


const SPEED := 40

@export var player: Node2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	make_path()

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move_and_slide()
	
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	
func make_path() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	make_path()
