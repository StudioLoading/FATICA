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

var idle_anim = ["Idle", "Speak"]
var idle
signal bubble

enum STATES {WALKING, JUMPING, SABBIEMOBILI, RAFFICA, MORTO, TEMPESTA, BANDITI, LOCKED}
onready var state = STATES.JUMPING

onready var fx_step = preload("res://asset/audio/fx/step.ogg")
onready var fx_grunt = preload("res://asset/audio/fx/grunt_woman2.ogg")
onready var fx_heal = preload("res://asset/audio/fx/heal.ogg")
onready var fx_insults= preload("res://asset/audio/voci/insults.ogg")

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

	if jump and is_on_floor() and state != STATES.LOCKED:
		jumping = true
		velocity.y = jump_speed
	elif jumping and !is_on_floor() and state != STATES.TEMPESTA and state != STATES.SABBIEMOBILI:
		state = STATES.JUMPING
	if jump and state == STATES.SABBIEMOBILI :
		velocity.y = jump_speed
	if right and state != STATES.LOCKED:
		velocity.x += run_speed
	if left and state != STATES.LOCKED:
		velocity.x -= run_speed

func _physics_process(delta):
	if state == STATES.MORTO:
		return
	get_input()
	
	
	
	if velocity.x != 0 and state != STATES.TEMPESTA:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	velocity.y += gravity * delta
	
	if state == STATES.LOCKED :
			print('state',state)
			$AnimatedSprite.play("Walk")
			velocity.x += 50
			

		
	if state == STATES.BANDITI:	
		print('state','STATES.BANDITI')	
		if ($AnimatedSprite.get_frame() == 28):
			$afx_grunt.stream = fx_insults
			$afx_grunt.play()
			emit_signal("bubble")
			$Timer.start()
	else:
		get_node("Sprite").visible = false	
		
			
	
	if state != STATES.SABBIEMOBILI and state != STATES.LOCKED:
		if (right or left) and is_on_floor() and state != STATES.TEMPESTA:
			$AnimatedSprite.play("Run")
		
		elif !left and !right and state != STATES.TEMPESTA and state != STATES.BANDITI and is_on_floor():
			$AnimatedSprite.play("Idle")
			#$AnimatedSprite.animation = idle_anim[randi() % idle_anim.size()]
		
		
		if state == STATES.TEMPESTA and $AnimatedSprite.animation != 'ProtectWalk':
			$AnimatedSprite.play("Protectwalk")
		
			

	if jumping and is_on_floor() and state == STATES.JUMPING :
		$AnimatedSprite.play("Jump")
		jumping = false
		$afx_step.stream = fx_step
		$afx_step.play()

	if state == STATES.SABBIEMOBILI:
		energy -= 0.15

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if healing and energy<energy_max:
		energy += 0.1
	
	

func _process(delta):
	if energy < 0 and state != STATES.MORTO:
		state = STATES.MORTO
		energy = 0
		$AnimatedSprite.play('Die')
		yield($AnimatedSprite, 'animation_finished')
		$timerGameOver.start()
		
	

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		#$Camera2D.enabled = true
		state = STATES.SABBIEMOBILI
		$AnimatedSprite.play('sabbiemobili')
		print('Dentro la sabbia mobile')
		emit_signal("camera_shake_requested")
		jump_speed = -300
	


func _on_Area2D_body_exited(body):
	if body.is_in_group('player'):
		state = STATES.WALKING
		emit_signal("camera_shake_stop")
		print('Fuori la sabbia mobile')
		gravity = gravity_default
		jump_speed = jump_speed_default
		$afx_grunt.stream = fx_grunt
		$afx_grunt.play()
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group('enemy'):
		print('ENEMY collidin')
		$afx_grunt.stream = fx_grunt
		$afx_grunt.play()
		energy -= 10
		


func _on_timerGameOver_timeout():
	get_tree().change_scene("res://GameOver.tscn")
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if area.is_in_group('a_tempesta'):
		#print('a_tempestaa_tempestaa_tempestaa_tempesta')
		relative_velocity = Vector2(-150, 0)
		state = STATES.TEMPESTA
		$afx_grunt.stream = fx_grunt
		$afx_grunt.play()
	if area.is_in_group('oasi'):
		$afx_grunt.stream = fx_heal
		$afx_grunt.play()
		healing = true
	if area.is_in_group('banditcontract'):
		#$Camera2D.enabled = true
		state = STATES.LOCKED
		$AnimatedSprite.play("Walk")
		print('banditcontract')
	if area.is_in_group('ParlaBanditi'):
		#$Camera2D.enabled = true
		state = STATES.BANDITI
		print('state',state)
		$AnimatedSprite.play("Wearmask")
		velocity.x += 0
		
		
	
func _on_Area2D_area_exited(area):
	if area.is_in_group('a_tempesta'):
		relative_velocity = Vector2.ZERO
		state = STATES.WALKING
		$afx_grunt.stream = fx_grunt
		$afx_grunt.play()
		yield($afx_grunt, "finished")
		$afx_grunt.play()
	if area.is_in_group('oasi'):
		$afx_grunt.stop()
		healing = false
	if area.is_in_group('banditcontract'):
		$afx_grunt.stop()
		state = STATES.WALKING
		relative_velocity = Vector2.ZERO
	
	
func _on_Timer_timeout():
	$AnimatedSprite.play("Speak")
	get_node("Sprite").visible = true
	
