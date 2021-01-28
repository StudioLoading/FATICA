extends Camera2D

onready var timer : Timer = $timer

export var amplitude : = 3.5
export var duration : = 0.3 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

var enabled : = false

export onready var initial_camera_offset = Vector2(0, 0)


func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration


func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = initial_camera_offset+Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _on_timer_timeout():
	self.shake = false
	

func set_duration(value: float) -> void:
	duration = value
	$timer.wait_time = duration


func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	offset = initial_camera_offset
	if shake:
		$timer.start()


func _on_player_camera_shake_requested():
	if not enabled:
		$timer.stop()
		return
	self.shake = true
	pass # Replace with function body.


func _on_player_camera_shake_stop():
	self.set_shake(false)
	
	pass # Replace with function body.
