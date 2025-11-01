extends CharacterBody2D


const SPEED: float = 150.0
const JUMP_VELOCITY: float = -300.0
const DASH_SPEED: float = 500.0
const INITIAL_DASH_TIMES: int = 1
const ACCELERATION: float = 18.5
const FRICTION:float = 22.5
const GRAVITY_WALL: float = 100.0
const WALL_JUMP_FORCE: float = 200.0

var current_dash_times: int = INITIAL_DASH_TIMES
var is_dashing := false
var in_dash_cooldown := false
var in_spell_cooldown := false
var initial_jump_times := 2
var current_jump_times: int = initial_jump_times
var look_dir_x: int = 1

const WALL_CONTACT_COYOTE_TIME: float = 0.1
var wall_contact_coyote: float = 0.0


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
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if !is_dashing:
		if  !is_on_floor():
			velocity += get_gravity() * delta
			animation.play("jump")

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
			if Input.is_action_just_pressed("jump") and current_jump_times > 0:
					velocity.y = JUMP_VELOCITY
					current_jump_times -= 1
			if direction:
				animation.play("run")
			else:
				animation.play("idle")
		else:
			if Input.is_action_just_pressed("jump") and current_jump_times > 0 and GameManager.acuired_double_jump:
				velocity.y = JUMP_VELOCITY
				current_jump_times -= 1
					
		if GameManager.acuired_wall_jump:
			if is_on_floor() or wall_contact_coyote > 0.0:
				current_jump_times = initial_jump_times
				current_dash_times = INITIAL_DASH_TIMES
				if Input.is_action_just_pressed("jump"):
					velocity.y = JUMP_VELOCITY
					current_jump_times -= 1
					if wall_contact_coyote > 0.0:
						velocity.x = x_input * WALL_JUMP_FORCE
				
				if direction:
					animation.play("run")
				else:
					animation.play("idle")
					
				
			if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
				look_dir_x = sign(velocity.x)
				wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
				velocity.y = GRAVITY_WALL
			else:
				wall_contact_coyote -= delta
			
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
