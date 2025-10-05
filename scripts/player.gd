extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animation.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			animation.flip_h = false
		elif direction == -1:
			animation.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) 
		
	if is_on_floor():
		if direction:
			animation.play("run")
		else:
			animation.play("idle")
	move_and_slide()
