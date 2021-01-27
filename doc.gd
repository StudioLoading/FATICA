extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var jump_speed_default = -400
export (int) var gravity = 1200
export (int) var gravity_default = 1200

var velocity = Vector2()
var jumping = false

enum STATES {WALKING, JUMPING, SABBIEMOBILI, RAFFICA}
onready var state = STATES.WALKING

signal camera_shake_requested
signal camera_shake_stop


func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if jump and state == STATES.SABBIEMOBILI:
		velocity.y = jump_speed
	if state == STATES.RAFFICA:
		velocity.x = -20
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		$Camera2D.enabled = true
		state = STATES.SABBIEMOBILI
		print('Dentro la sabbia mobile')
		$Camera2D.drag_margin_bottom = 1
		emit_signal("camera_shake_requested")
		gravity = 2000
		jump_speed = -300
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group('player'):
		state = STATES.WALKING
		$Camera2D.drag_margin_bottom = 0.4;
		emit_signal("camera_shake_stop")
		print('Fuori la sabbia mobile')
		gravity = gravity_default
		jump_speed = jump_speed_default
	pass # Replace with function body.
