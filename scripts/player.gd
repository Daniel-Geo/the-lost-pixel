class_name Player extends CharacterBody2D


var speed: float = 150.0
var jump_velocity: float = -300.0
var wall_gravity: float = 100.0

const DASH_SPEED: float = 500.0
const INITIAL_DASH_TIMES: int = 1
const ACCELERATION: float = 18.5

var in_spell_cooldown := false
var current_dash_times: int = INITIAL_DASH_TIMES
var is_dashing := false
var in_dash_cooldown := false
var initial_extra_jumps := 1
var current_extra_jumps: int = initial_extra_jumps
var look_dir_x: int = 1
var is_player_flipped:= false
var is_gravity_flipped := false

const WALL_CONTACT_COYOTE_TIME: float = 0.2
var wall_contact_coyote: float = 0.0


@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sfx: AudioStreamPlayer = $JumpSFX
@onready var explosion_particles: CPUParticles2D = $Explosion
@onready var dash_particles: CPUParticles2D = $Dash
@onready var walking_particles: CPUParticles2D = $WalkingParticles
@onready var jumping_particles: CPUParticles2D = $JumpingParticles
@onready var spell_sfx: AudioStreamPlayer = $SpellSFX
@onready var spell_cooldown: Timer = $SpellCooldown
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown

func _ready() -> void:
	Engine.time_scale = 1.0
	up_direction = Vector2.UP
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
	if get_tree().current_scene.name == "Level6":
		get_node("Camera2D").limit_bottom = 256
		get_node("Camera2D").limit_top = -256

func _physics_process(delta: float) -> void:
	if !is_dashing:
		if  !is_on_floor():
			animation.play("jump")
			if is_player_flipped:
				velocity -= get_gravity() * delta
			else:
				velocity += get_gravity() * delta
			
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			if direction == 1:
				animation.flip_h = false
			elif direction == -1:
				animation.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, speed) 
		
		if is_on_floor():
			current_dash_times = INITIAL_DASH_TIMES
			current_extra_jumps = initial_extra_jumps
			if Input.is_action_just_pressed("jump"):
				if GameManager.acquired_flip_jump:
					flip_jump()
				else:
					velocity.y = jump_velocity
					jumping_particles.emitting = true
					jump_sfx.play()
			
			if direction:
				animation.play("run")
				walking_particles.emitting = true
			else:
				animation.play("idle")
				walking_particles.emitting = false
				
			if Input.is_action_just_pressed("down") and GameManager.acquired_drop_through_platform:
				if is_player_flipped or is_gravity_flipped:
					position.y -= 1
				else:
					position.y += 1
		else:
			walking_particles.emitting = false
			if Input.is_action_just_pressed("jump") and !is_on_wall() and current_extra_jumps > 0 and GameManager.acquired_double_jump:
				velocity.y = jump_velocity
				jumping_particles.emitting = true
				jump_sfx.play()
				current_extra_jumps -= 1
				
		if GameManager.acquired_wall_jump:
			if is_on_wall():
				current_extra_jumps = initial_extra_jumps
				current_dash_times = INITIAL_DASH_TIMES
				if Input.is_action_just_pressed("jump") and wall_contact_coyote > 0.0:
					velocity.y = jump_velocity
					jump_sfx.play()
					
			if (!is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0 and (!is_gravity_flipped or !is_player_flipped)) or (!is_on_floor() and velocity.y < 0 and is_on_wall() and velocity.x != 0 and (is_gravity_flipped or is_player_flipped)):
				current_extra_jumps = initial_extra_jumps
				look_dir_x = sign(velocity.x)
				animation.play("wall_slide")
				wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
				velocity.y = wall_gravity
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
	
	
	if Input.is_action_just_pressed("use_spell") and !in_spell_cooldown and GameManager.acquired_spell:
		use_spell()
		in_spell_cooldown = true
		spell_cooldown.start()
		
	if Input.is_action_just_pressed("dash") and current_dash_times > 0 and !is_dashing and !in_dash_cooldown and GameManager.acquired_dash:
		dash()
		in_dash_cooldown = true
		dash_cooldown.start()
		
	if Input.is_action_just_pressed("flip") and is_on_floor() and GameManager.acquired_flip:
		flip()
		
		
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
	if has_node("CollisionShape2D"):
		current_dash_times -= 1
		is_dashing = true
		dash_particles.emitting = true
		dash_timer.start()
	
func flip():
	jump_velocity *= -1
	wall_gravity *= -1
	scale.y *= -1
	if is_gravity_flipped:
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
		up_direction = Vector2.UP
	else:
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.UP)
		up_direction = Vector2.DOWN
	is_gravity_flipped = !is_gravity_flipped
	
func flip_jump():
	jump_velocity *= -1
	wall_gravity *= -1
	scale.y *= -1
	up_direction = Vector2.UP if is_player_flipped else Vector2.DOWN
	is_player_flipped = !is_player_flipped

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


func _on_termination_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("traps") and get_node("CollisionShape2D"):
		Engine.time_scale = 0.5
		get_node("HurtSFX").play()
		explosion_particles.emitting = true
		get_node("CollisionShape2D").queue_free()
		get_node("KillTimer").start()
