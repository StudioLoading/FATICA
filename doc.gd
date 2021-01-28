extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var jump_speed_default = -400
export (int) var gravity = 1200
export (int) var gravity_default = 1200

var velocity = Vector2()
var relative_velocity = Vector2()
var jumping = false
var energy = 100

enum STATES {WALKING, JUMPING, SABBIEMOBILI, RAFFICA, MORTO}
onready var state = STATES.WALKING

signal camera_shake_requested
signal camera_shake_stop

var left
var right

func get_input():
	velocity.x = relative_velocity.x
	right = Input.is_action_pressed('ui_right')
	left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if jump and state == STATES.SABBIEMOBILI:
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func _physics_process(delta):
	if state == STATES.MORTO:
		return
	get_input()
	get_node("../GUI/energyLabel").text = str(energy)
	
	
	velocity.y += gravity * delta
	
	#if velocity.x != 0 and (
	if right or left:
		$AnimatedSprite.play("Run")
	if right:
		$AnimatedSprite.flip_h = false
	if left:
		$AnimatedSprite.flip_h =true
#		if relative_velocity == Vector2.ZERO or left:
#			$AnimatedSprite.flip_h = velocity.x < 0
		
	#if velocity.x == 0 :
	if !left and !right:
		$AnimatedSprite.play("Idle")
	
	if jumping and is_on_floor():
		jumping = false
	if state == STATES.SABBIEMOBILI:
		energy -= 0.15
	velocity = move_and_slide(velocity, Vector2(0, -1))
	pass

func _process(delta):
	if energy < 0 and state != STATES.MORTO:
		state = STATES.MORTO
		$timerGameOver.start()
		energy = 0
		

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		$Camera2D.enabled = true
		state = STATES.SABBIEMOBILI
		print('Dentro la sabbia mobile')
		#$Camera2D.drag_margin_bottom = 1
		emit_signal("camera_shake_requested")
		#gravity = 2000
		#gravity = 300
		jump_speed = -300
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group('player'):
		state = STATES.WALKING
		#$Camera2D.drag_margin_bottom = 0.4;
		emit_signal("camera_shake_stop")
		print('Fuori la sabbia mobile')
		gravity = gravity_default
		jump_speed = jump_speed_default
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group('enemy'):
		print('enemyenemyenemyenemy')
#		energy-= 11
		


func _on_timerGameOver_timeout():
	get_tree().change_scene("res://GameOver.tscn")
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if area.is_in_group('a_tempesta'):
		relative_velocity = Vector2(-150, 0)
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if area.is_in_group('a_tempesta'):
		relative_velocity = Vector2.ZERO
	pass # Replace with function body.
