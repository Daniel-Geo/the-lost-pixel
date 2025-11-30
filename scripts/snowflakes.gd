extends CPUParticles2D

@onready var timer: Timer = $Timer

var mat := self.material as ShaderMaterial
var range := RandomNumberGenerator.new()
var min_val := 0
var x_max_val := 5
var y_max_val := 2
var rand_x := 0
var rand_y := 0

func _on_timer_timeout() -> void:
	rand_x = range.randi_range(min_val, x_max_val)
	rand_y = range.randi_range(min_val, y_max_val)
	mat.set_shader_parameter("region_px", Vector4(rand_x * 9, rand_y * 9, 9.0, 9.0))
	timer.start()
