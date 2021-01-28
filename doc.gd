extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var jump_speed_default = -400
export (int) var gravity = 1200
export (int) var gravity_default = 1200
export (int) var energy_max = 100

var velocity = Vector2()
var relative_velocity = Vector2()
var jumping = true
var energy = energy_max

enum STATES {WALKING, JUMPING, SABBIEMOBILI, RAFFICA, MORTO, TEMPESTA}
onready var state = STATES.JUMPING

onready var fx_step = preload("res://asset/audio/fx/step.ogg")
onready var fx_grunt = preload("res://asset/audio/fx/grunt_woman2.ogg")

signal camera_shake_requested
signal camera_shake_stop

var left
var right
var healing

func get_input():
	velocity.x = relative_velocity.x
	right = Input.is_action_pressed('ui_right')
	left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	elif jumping and !is_on_floor() and state != STATES.TEMPESTA and state != STATES.SABBIEMOBILI:
		state = STATES.JUMPING
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
	
	
	if velocity.x != 0 and state != STATES.TEMPESTA:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	velocity.y += gravity * delta
	
	if state != STATES.SABBIEMOBILI:
		if (right or left) and is_on_floor() and state != STATES.TEMPESTA:
			$AnimatedSprite.play("Run")
		
		elif !left and !right and state != STATES.TEMPESTA and is_on_floor():
			$AnimatedSprite.play("Idle")
		
		if state == STATES.TEMPESTA and $AnimatedSprite.animation != 'ProtectWalk':
			$AnimatedSprite.play("Protectwalk")

	if jumping and is_on_floor() and state == STATES.JUMPING :
		$AnimatedSprite.play("Jump")
		jumping = false
		$AudioStreamPlayer.stream = fx_step
		$AudioStreamPlayer.play()

	if state == STATES.SABBIEMOBILI:
		energy -= 0.15

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if healing and energy<energy_max:
		energy += 0.1
	
	#print('state',state)

func _process(delta):
	if energy < 0 and state != STATES.MORTO:
		state = STATES.MORTO
		$timerGameOver.start()
		energy = 0
	

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		#$Camera2D.enabled = true
		state = STATES.SABBIEMOBILI
		$AnimatedSprite.play('sabbiemobili')
		print('Dentro la sabbia mobile')
		emit_signal("camera_shake_requested")
		jump_speed = -300
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group('player'):
		state = STATES.WALKING
		emit_signal("camera_shake_stop")
		print('Fuori la sabbia mobile')
		gravity = gravity_default
		jump_speed = jump_speed_default
		$AudioStreamPlayer.stream = fx_grunt
		$AudioStreamPlayer.play()
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
		#print('a_tempestaa_tempestaa_tempestaa_tempesta')
		relative_velocity = Vector2(-150, 0)
		state = STATES.TEMPESTA
		$AudioStreamPlayer.stream = fx_grunt
		$AudioStreamPlayer.play()
	if area.is_in_group('oasi'):
		healing = true
	


func _on_Area2D_area_exited(area):
	if area.is_in_group('a_tempesta'):
		relative_velocity = Vector2.ZERO
		state = STATES.WALKING
		$AudioStreamPlayer.stream = fx_grunt
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		$AudioStreamPlayer.play()
	if area.is_in_group('oasi'):
		healing = false
	
