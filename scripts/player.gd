extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 500.0
const INITIAL_DASH_TIMES = 1

var current_dash_times = INITIAL_DASH_TIMES
var is_dashing := false
var in_dash_cooldown := false
var in_spell_cooldown := false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_particles: CPUParticles2D = $Explosion
@onready var dash_particles: CPUParticles2D = $Dash
@onready var spell_sfx: AudioStreamPlayer = $SpellSFX
@onready var spell_cooldown: Timer = $SpellCooldown
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown

func _ready() -> void:
	Engine.time_scale = 1.0

func _physics_process(delta: float) -> void:
	if !is_dashing:
		if not is_on_floor():
			velocity += get_gravity() * delta
			animation.play("jump")

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

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
			current_dash_times = INITIAL_DASH_TIMES
			if direction:
				animation.play("run")
			else:
				animation.play("idle")
	else:
		animation.play("dash")
		velocity.y = 0
		if !animation.flip_h:
			velocity.x = 1 * DASH_SPEED
		else:
			velocity.x = -1 * DASH_SPEED
		
	move_and_slide()
	
	if Input.is_action_just_pressed("use_spell") and !in_spell_cooldown and GameManager.acuired_spell:
		use_spell()
		in_spell_cooldown = true
		spell_cooldown.start()
		
	if Input.is_action_just_pressed("dash") and current_dash_times > 0 and !is_dashing and !in_dash_cooldown and GameManager.acuired_dash:
		dash()
		in_dash_cooldown = true
		dash_cooldown.start()

func use_spell():
	if has_node("CollisionShape2D"):
		const PROJECTILE = preload("res://scenes/soul_spell_projectile.tscn")
		var new_projectile = PROJECTILE.instantiate()
		if animation.flip_h == false:
			new_projectile.rotation = 0
		elif animation.flip_h == true:
			new_projectile.rotation = PI
		add_child(new_projectile)
		spell_sfx.play()


func dash():
	current_dash_times -= 1
	is_dashing = true
	dash_particles.emitting = true
	dash_timer.start()

func _on_kill_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	
func _on_spell_cooldown_timeout() -> void:
	in_spell_cooldown = false

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_particles.emitting = false

func _on_dash_cooldown_timeout() -> void:
	in_dash_cooldown = false
